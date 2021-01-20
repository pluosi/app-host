module PkgAdapter

  class BaseAdapter
    # attr_accessor :file

    def initialize(path)
      unless File.exist? path
        raise "#{path} is not a exist file"
      end
      @path = path
      # parse if @path
    end

    def plat
    end

    def parse
    end

    def app_name
    end

    def app_version
    end

    def app_build
    end

    def app_icon
    end

    def app_size
    end

    def app_bundle_id
    end

    def app_uniq_key
    end

    def ext_info
    end

    def tmp_dir
      "tmp/pkgs/#{CGI::escape(plat)}_#{Digest::MD5.hexdigest(@path)}"
    end

    def app_size_mb
      '%.2f' % (app_size / (1024*1024.0))
    end

    def pkg_mb5
        Digest::MD5.hexdigest File.read(@path)
    end
    

  end
end