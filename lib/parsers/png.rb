# Helper method to fix Apple's stupid png optimizations
# Adapted from:
#   http://www.axelbrz.com.ar/?mod=iphone-png-images-normalizer
#   https://github.com/peperzaken/iPhone-optimized-PNG-reverse-script/blob/master/Peperzaken/Ios/DecodeImage.php
# PNG spec: http://www.libpng.org/pub/png/spec/1.2/PNG-Contents.html

require 'zlib'
require 'logger'

module PNG
  extend self

  attr_accessor :logger

  PNGHEADER = "\x89PNG\r\n\x1A\n".force_encoding('ASCII-8BIT')

  # TODO: Accept output file path?
  def normalize(file_path)
    File.open(file_path, 'rb') do |f|
      header_data = f.read(8)

      # Check if it's a PNG
      if header_data != PNGHEADER
        logger.error "File is not a PNG" if logger
        # TODO: Raise exception?
        return nil
      end

      chunks = []
      idat_data_chunks = []
      iphone_compressed = false

      while !f.eof?
        # Unpack the chunk
        chunk = {}
        chunk['length'] = f.read(4).unpack("L>").first
        chunk['type'] = f.read(4)
        data = f.read(chunk['length'])  # Can be 0...
        chunk['crc'] = f.read(4).unpack("L>").first

        logger.debug "Chunk found :: length: #{chunk['length']}, type: #{chunk['type']}" if logger

        # This chunk is first when it's an iPhone compressed image
        if chunk['type'] == 'CgBI'
          iphone_compressed = true
        end

        # Extract the header
        #   Width:              4 bytes
        #   Height:             4 bytes
        #   Bit depth:          1 byte
        #   Color type:         1 byte
        #   Compression method: 1 byte
        #   Filter method:      1 byte
        #   Interlace method:   1 byte
        if chunk['type'] == 'IHDR' && iphone_compressed
          @width = data[0, 4].unpack("L>").first
          @height = data[4, 4].unpack("L>").first
          @bit_depth = data[8, 1].unpack("C").first
          @filter_method = data[11, 1].unpack("C").first
          logger.info "Image size: #{@width}x#{@height} (#{@bit_depth}-bit)" if logger
        end

        # Extract and mutate the data chunk if needed (can be multiple)
        if chunk['type'] == 'IDAT' && iphone_compressed
          idat_data_chunks << data
          next
        elsif idat_data_chunks.length > 0
          # All the IDAT chunks must be consecutive. Consequently, if we reach this point, we've
          # already seen at least one.
          idat_data = idat_data_chunks.join('')
          uncompressed = zlib_inflate(idat_data)

          # Let's swap some colors
          new_data = ''
          (0...@height).each do |y|
            i = new_data.length

            # With filter method 0, the only one currently defined, we have to prepend a filter type byte to each scan line.
            # Currently, we just copy what was there before (though this could be wrong).
            new_data << uncompressed[i]

            (0...@width).each do |x|
              j = new_data.length

              # Swap BGRA to RGBA
              new_data << uncompressed[j + 2]  # Red
              new_data << uncompressed[j + 1]  # Green
              new_data << uncompressed[j + 0]  # Blue
              new_data << uncompressed[j + 3]  # Alpha
            end
          end

          # Compress the data again after swapping (this time with the headers, CRC, etc)
          # TODO: Split into multiple IDAT chunks
          idat_data = zlib_deflate(new_data)
          idat_chunk = {
            'type' => 'IDAT',
            'length' => idat_data.length,
            'data' => idat_data,
            'crc' => Zlib::crc32('IDAT' + idat_data)
          }
          chunks << idat_chunk
        end

        chunk['data'] = data
        chunks << chunk
      end  # EOF

      # Rebuild the image without the CgBI chunk
      out = header_data
      chunks.each do |chunk|
        next if chunk['type'] == 'CgBI'
        logger.debug "Writing #{chunk['type']}" if logger

        out << [chunk['length']].pack("L>")
        out << chunk['type']
        out << chunk['data']
        out << [chunk['crc']].pack("L>")
      end
      out
    end  # File.open
  end

  private
    def zlib_inflate(string)
      zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
      buf = zstream.inflate(string)
      zstream.close
      buf
    end

    def zlib_deflate(string, level = Zlib::DEFAULT_COMPRESSION)
      zstream = Zlib::Deflate.new(level)
      buf = zstream.deflate(string, Zlib::FINISH)
      zstream.close
      buf
    end
end


