module PkgAdapter

  class Apk < BaseAdapter
    require 'ruby_apk'

    def parse
      @apk = Android::Apk.new(@path)
      if file_name = @apk.icon.keys.last
        icon = @apk.icon[file_name]
        path = tmp_dir
        FileUtils.rm_rf path
        @app_icon = "#{path}/#{File.basename(file_name)}"
        dirname = File.dirname(@app_icon)
        FileUtils.mkdir_p dirname
        File.open("#{@app_icon}", 'wb') { |file| file.write(icon) } if icon
      end
    end

    def plat
      'android'
    end

    def app_uniq_key
      :build
    end

    def app_name
      @apk.manifest.label
    end

    def app_version
      @apk.manifest.version_name
    end

    def app_build
      "#{@apk.manifest.version_code}"
    end

    def app_icon
      @app_icon
    end

    def app_size
      File.size(@path)
    end

    def app_bundle_id
      @apk.manifest.package_name
    end

    def ext_info
      manifest = @apk.manifest
      info = {
        "包信息" => [
          "包名: #{self.app_bundle_id}",
          "体积: #{app_size_mb}MB",
          "MD5: #{pkg_mb5}",
          "最小SDK: #{manifest.min_sdk_ver}",
        ],
        "signs" => @apk.signs.map { |path, sign| path },
        "certs" => @apk.certificates.map { |path, cert| path },
        "permissions" => manifest.use_permissions,
      }
    end

  end
end