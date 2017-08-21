module PkgAdapter

  class Ipa < BaseAdapter
    
    require 'zip'

    def parse
        Zip::File.open(@path) do |zip_file|
          # Handle entries one by one

          path = "tmp/pkgs/#{Digest::MD5.hexdigest(@path)}"
          FileUtils.rm_rf path
          # zip_file.each do |entry|
          #   # Extract to file/directory/symlink
          #   p "Extracting #{entry.name}"
          #   entry.extract("#{path}/#{entry.name}")
          #   # content = entry.get_input_stream.read if entry.get_input_stream.respond_to? :read
          # end

          profile_contents = zip_file.glob('Payload/*.app/embedded.mobileprovision').first.get_input_stream.read
          @profile = ConfigParser.mobileprovision profile_contents

          plist = zip_file.glob('Payload/*.app/Info.plist').first.get_input_stream.read
          
          @plist = ConfigParser.plist plist

          entry = zip_file.glob('Payload/*.app/AppIcon[6,4]0x[6,4]0@[2,3]x.png').last
          if !entry
            raise "can find AppIcon"
          end
          @app_icon = "#{path}/#{entry.name}"
          dirname = File.dirname(@app_icon)
          FileUtils.mkdir_p dirname

          entry.extract @app_icon
          
          #uncrush
          png = PNG.normalize(@app_icon)
          File.open("#{@app_icon}", 'wb') { |file| file.write(png) } if png

        end
    end

    def app_name
      @plist.tree["CFBundleDisplayName"]
    end

    def app_version
      @plist.tree["CFBundleShortVersionString"]
    end

    def app_build
      @plist.tree["CFBundleVersion"]
    end

    def app_icon
      @app_icon
    end

    def app_size
      File.size(@path)
    end

  end

  class ConfigParser
    def self.mobileprovision(stream)
      profile = stream.slice(stream.index('<?'), stream.length)
      Nokogiri.XML(profile)
    end

    def self.plist(stream)
      Bplist.parse(stream)
    end
  end
end