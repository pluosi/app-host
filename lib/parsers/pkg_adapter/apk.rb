module PkgAdapter

  class Apk < BaseAdapter
    
    require 'ruby_apk'
    require 'zip'

    ANDROID_MANIFEST = 'AndroidManifest.xml'
    RESOURCE = 'resources.arsc'

    def parse

      Zip::File.open(@path) do |zip_file|
          # Handle entries one by one
          path = tmp_dir
          
          FileUtils.rm_rf(path) if File.exist?(path)

          manifest = _file(zip_file,ANDROID_MANIFEST)
          resources = _file(zip_file,RESOURCE)

          @resource = Android::Resource.new(resources.get_input_stream.read)
          @manifest = Android::Manifest.new(manifest.get_input_stream.read,@resource)

          icon_id = @manifest.doc.elements['/manifest/application'].attributes['icon']
          if /^@(\w+\/\w+)|(0x[0-9a-fA-F]{8})$/ =~ icon_id
            drawables = @resource.find(icon_id)
            @icons = Hash[drawables.map {|name| [name, _file(zip_file,name)] }]
          else
            @icons = { icon_id => _file(zip_file,icon_id) } # ugh!: not tested!!
          end
        
          if (file_name = @icons.keys.last) && file_name.end_with?(".png")
            entry = _file(zip_file,file_name)
            if entry
              @app_icon = "#{path}/#{entry.name}"
              dirname = File.dirname(@app_icon)
              FileUtils.mkdir_p dirname
              entry.extract @app_icon        
            else
              p "can find AppIcon:#{file_name}"
            end
          else
            p "can find AppIcon"
          end
      end

    end

    def _file(zip_file,name)
      zip_file.glob(name).first
    end

    def plat
      'android'
    end

    def app_uniq_key
      :build
    end

    def app_name
      @manifest.label
    end

    def app_version
      @manifest.version_name
    end

    def app_build
      "#{@manifest.version_code}"
    end

    def app_icon
      @app_icon
    end

    def app_size
      File.size(@path)
    end

    def app_bundle_id
      @manifest.package_name
    end

    def ext_info
      info = {
        "包信息" => [
          "包名: #{self.app_bundle_id}",
          "体积: #{app_size_mb}MB",
          "MD5: #{pkg_mb5}",
          "最小SDK: #{@manifest.min_sdk_ver}",
        ],
        "permissions" => @manifest.use_permissions,
      }
    end

  end
end