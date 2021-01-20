require 'ruby_apk'

module Android

  class AXMLParser
    
    #重写，修复 bug
    def parse_tags
      # skip until START_TAG
      pos = @xml_offset
      pos += 4 until (word(pos) == TAG_START) #ugh!
      @io.pos -= 4

      # read tags
      #puts "start tag parse: %d(%#x)" % [@io.pos, @io.pos]

      # puts "parse_tags start..."

      until @io.eof?
        last_pos = @io.pos
        tag, tag1, line, tag3, ns_id, name_id = @io.read(4*6).unpack("V*")
        
        # puts "case:#{tag}"

        case tag
        when TAG_START
          # puts "TAG_START"
          tag6, num_attrs, tag8  = @io.read(4*3).unpack("V*")
          
          # puts @strings[name_id]

          elem = REXML::Element.new(@strings[name_id])
          # puts "start tag %d(%#x): #{@strings[name_id]} attrs:#{num_attrs}" % [last_pos, last_pos]
          @parents.last.add_element elem
          num_attrs.times do
            key, val = parse_attribute
            elem.add_attribute(key, val)
          end
          @parents.push elem
        when TAG_END
          # puts "TAG_END"
          @parents.pop
        when TAG_END_DOC
          # not implemented END yet.
          # puts "TAG_END_DOC"
          # break
        when TAG_TEXT
          # puts "TAG_TEXT"
          text = REXML::Text.new(@strings[ns_id])
          @parents.last.text = text
          dummy = @io.read(4*1).unpack("V*") # skip 4bytes
        when TAG_START_DOC, TAG_CDSECT, TAG_ENTITY_REF
          # not implemented yet.
          # puts "not implemented yet."
        else
          # puts "ReadError."
          raise ReadError, "pos=%d(%#x)[tag:%#x]" % [last_pos, last_pos, tag]
        end
      end
    end

  end

end
