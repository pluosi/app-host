# bplist.rb: binary property list reader/parser for ruby
#  by Murachue
# 20091229.2218: initialize
# 20100101.1348: check Kconv, hash dump improved, modulized, renamed dumpself->dump.
# 20120916.1906: ruby1.9-ize. add runnable test code. tested with ruby 1.9.3p0-i386-mingw32

if not defined? Kconv::REVISION
	require 'kconv'
end

module Bplist
	VERSION = "20120916.1906"
	HostKCode = Kconv::UTF8

	class DataString < String
		def inspect
			return "<DATA\##{super.inspect}>"
		end
	end
	class UIDString < String
		def inspect
			return "<UID\##{super.inspect}>"
		end
	end

	def self.parse(buf)
		return BPListParser.new(buf)
	end

	class BPListParser
		def initialize(bytes)
			@bplist = bytes
			self.parse
		end

		@tree = nil
		attr_reader :tree

		def parse
			if @bplist[0..5] != "bplist"
				raise "NOT bplist."
			end

			if @bplist[6..7] != "00"
				raise "unknown version! (#{bplist[6..7]})"
			end

			#    uint8_t     _sortVersion;
			#    uint8_t	_offsetIntSize;
			#    uint8_t	_objectRefSize;
			#    uint64_t	_numObjects;
			#    uint64_t	_topObject;
			#    uint64_t	_offsetTableOffset;

			def unpack64(s)
				a = s.unpack("NN")
				return (a[0] << 32) | a[1]
			end

			# read trailer
			@t_offsetTableOffset = unpack64(@bplist[-8..-1])
			@t_topObject = unpack64(@bplist[-16..-9])
			@t_numObject = unpack64(@bplist[-24..-17])

			@t_objRefSize = @bplist[-25].unpack("C")[0]
			@t_objIntSize = @bplist[-26].unpack("C")[0]
			@t_sortVersion = @bplist[-27].unpack("C")[0]

			# check trailer
			if @t_sortVersion != 0
				raise "sortVersion unsupported (#{@t_sortVersion})"
			end
			#p offsetTableOffset, topObject, numObject

			#puts "INFO: #{@t_numObject} objects."

			def readVar(d, o, s)
				n = 0
				(0..(s - 1)).each{|i|
					n <<= 8
					n = n | d[o + i].ord
				}
				#puts "readVar: o,s=#{o},#{s}, n=#{n}"
				return n
			end

			@objOffsets = []
			(0..(@t_numObject - 1)).each{|i|
				@objOffsets << readVar(@bplist, @t_offsetTableOffset + @t_objIntSize * i, @t_objIntSize)
			}

			#p objOffsets

			# null   0000 0000
			# bool   0000 1000 // false
			# bool   0000 1001 // true
			# fill   0000 1111 // fill byte
			# int    0001 nnnn ...       // # of bytes is 2^nnnn, big-endian bytes
			# real   0010 nnnn ...       // # of bytes is 2^nnnn, big-endian bytes
			# date   0011 0011 ...       // 8 byte float follows, big-endian bytes
			# data   0100 nnnn [int] ... // nnnn is number of bytes unless 1111 then int count follows, followed by bytes
			# string 0101 nnnn [int] ... // ASCII string, nnnn is # of chars, else 1111 then int count, then bytes
			# string 0110 nnnn [int] ... // Unicode string, nnnn is # of chars, else 1111 then int count, then big-endian 2-byte shorts
			#        0111 xxxx           // unused
			# uid    1000 nnnn ...       // nnnn+1 is # of bytes
			#        1001 xxxx                       // unused
			# array  1010 nnnn [int] objref*         // nnnn is count, unless '1111', then int count follows
			#        1011 xxxx                       // unused
			#        1100 xxxx                       // unused
			# dict   1101 nnnn [int] keyref* objref* // nnnn is count, unless '1111', then int count follows
			#        1110 xxxx                       // unused
			#        1111 xxxx                       // unused

			def parseInt(b, o)
				if b[o].ord >> 4 != 0b0001
					raise "NotINT"
				end

				l = 2 ** (b[o].ord & 0x0F)
				v = readVar(b, o + 1, l)

				#p b[o].to_s(16), b[o+1].to_s(16), l, v

				return v, l
			end

			def readObj(id)
				off = @objOffsets[id]
				#puts id, @objOffsets.length, off
				#raise "Overrun" if id > @objOffsets.length
				cmd = @bplist[off].ord
				data = nil
				if cmd >> 4 == 0b0000
					case cmd & 0x0F
					when 0b0000	# null
						data = nil
					when 0b1000	# false
						data = false
					when 0b1001	# true
						data = true
					when 0b1111	# XXX: fillbyte??
						data = nil
					end
				else
					len = cmd & 0x0F
					doff = off + 1
					if cmd & 0x0F == 0b1111 && cmd != 0b1000
						#len = readVar(@bplist, off + 1, @t_objIntSize)
						#doff = off + 1 + @t_objIntSize
						len, l = parseInt(@bplist, off + 1)
						#exit if len == 0
						#p len, l
						doff = off + 1 + 1 + l
					end

					case cmd >> 4
					when 0b0001	# int
						#len = 2 ** len
						data, _ = parseInt(@bplist, off)
						#puts "INT: " + readVar(@bplist, doff, len).to_s
					when 0b0010	# real
						len = 2 ** len
						# TODO: really? reverse? unpack(f/d)?
						case len
						when 4
							data = @bplist[doff..(doff+len-1)].reverse.unpack("f")
						when 8
							data = @bplist[doff..(doff+len-1)].reverse.unpack("d")
						else
							raise "real.length is not 4 or 8 (#{len})"
						end
						#puts "REAL: " + readVar(@bplist, doff, len).to_s + " (#{len})"
						#puts "REAL: #{data} (#{len}) (#{@bplist[doff..(doff+len-1)].split(//).map{|c|c[0].to_s(16).rjust(2,"0")}.join(" ")})"
					when 0b0011	# date
						# len = 0b0011 8byte float
						if len != 0b0011
							raise "FATAL: date not followed by 0b0011!"
						end
						#data = readVar(@bplist, doff, 8).to_s
						data = [readVar(@bplist, doff, 8)].pack('Q').unpack('d')[0]	# XXX: holy shit code. endianess will be ignored.
						# Date is stored as CFAbsoluteTime; start from 2001/1/1.
						data = Time.gm(2001,1,1) + data
						#puts "DATE: " + data.to_s
					when 0b0100	# data
						#len = 64 if len > 64
						#puts "DATA: " + @bplist[doff .. (doff + len - 1)].inspect
						data = @bplist[doff .. (doff + len - 1)]
						#data = "data: " + data.unpack("H*").to_s

						if data[0..7] == "bplist00"	# special; bplist in bplist
							#b = BPListParser.new(String.new(data))
							b = BPListParser.new(data)
							#b.parse
							data = b.tree#dumpself(indent)
						else
							data = DataString.new(data)
						end

					when 0b0101	# string(ASCII)
						#len = 64 if len > 64
						data = @bplist[doff ... doff + len]
						#puts "STR_ASCII(#{id} #{off.to_s(16)} #{len}): " + data.inspect
					when 0b0110	# string(UTF16?)
						#len = 64 if len > 64
						len *= 2	# len = chars of unicode string...
						data = @bplist[doff ... doff + len]
						#data = Kconv.kconv(data, Kconv::SJIS, Kconv::UTF16)	# XXX
						data = data.kconv(HostKCode, Kconv::UTF16)
						#puts "STR_UNICODE: " + data
						#p id, off.to_s(16), len
					when 0b0111	# -unused
						raise "unknown type #{cmd}"
					when 0b1000	# uid: never seen...
						len = (cmd & 0x0F) + 1
						puts "UID: " + @bplist[doff ... doff + len].inspect
						data = UIDString.new(@bplist[doff ... doff + len].inspect)
					when 0b1001	# -unused
						raise "unknown type #{cmd}"
					when 0b1010	# array
						#len = 64 if len > 64
						#puts "ARRAY: " + @bplist[doff ... doff + len].inspect
						objs = @bplist[doff ... doff + len * @t_objRefSize]
						data = []
						(0...len).each{|i|
							oid = readVar(objs, i * @t_objRefSize, @t_objRefSize)
							data << readObj(oid)
						}
					when 0b1011	# -unused
						raise "unknown type #{cmd}"
					when 0b1100	# -unused
						raise "unknown type #{cmd}"
					when 0b1101	# dict
						#puts "DICT."
						objs = @bplist[doff ... doff + len * @t_objRefSize * 2]
						data = {}
						names = []
						(0...len).each{|i|
							noid = readVar(objs, i * @t_objRefSize, @t_objRefSize)
							names << readObj(noid)
						}
						(0...len).each{|i|
							void = readVar(objs, (len + i) * @t_objRefSize, @t_objRefSize)
							valu = readObj(void)
							#p names[i], valu
							data[names[i]] = valu
						}
					when 0b1110	# -unused
						raise "unknown type #{cmd}"
					when 0b1111	# -unused
						raise "unknown type #{cmd}"
					end
				end

				return data
			end

			#@objOffsets.each{|off|
			#	readObj(off)
			#}
			@tree = readObj(@t_topObject)
		end

		def _dump(obj, indent, indentrequire = true)
			#p obj.class
			is = "  " * indent
			case obj
			when Hash
				print is if indentrequire
				puts "{"
				obj.each_with_index{|o, i|
					#dump(o, indent + 1)
					_dump(o[0], indent + 1)
					print " = "
					_dump(o[1], indent + 1, false)
					
					print "," if i < (obj.length - 1)
					puts ""
				}
				print is + "}"
			when Array
				print is if indentrequire
				puts "["
				obj.each_with_index{|o, i|
					_dump(o, indent + 1)
					print "," if i < (obj.length - 1)
					puts ""
				}
				print is + "]"
			when DataString
				#if obj[0..7] == "bplist00"
				#	puts is + "// bplist00"
				#	b = BPListParser.new(String.new(obj))
				#	#b.parse
				#	b.dumpself(indent)
				#else
					print is if indentrequire
					print "<data:#{obj.unpack('H*').to_s}>"
				#end
			when String
				print is if indentrequire
				print "\"#{obj}\""
			when Time
				print is if indentrequire
				print "<#{obj.to_s}>"
			when Float
				print is if indentrequire
				print "#{obj.to_s}"
			when Fixnum
				print is if indentrequire
				print "#{obj.to_s}"
			when TrueClass
				print is if indentrequire
				print "YES"
			when FalseClass
				print is if indentrequire
				print "NO"
			else
				print is if indentrequire
				print "<#{obj.class}: #{obj.to_s}>"
			end
		end

		def dump(indent = 0)
			_dump @tree, indent
			puts
		end
	end
end
