module PkgAdapter

  class BaseAdapter
    # attr_accessor :file

    def initialize(path)
      unless File.exist? path
        raise "#{path} is not a exist file"
      end
      parse if @path = path
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

    def tmp_dir
      "tmp/pkgs/#{CGI::escape(plat)}_#{Digest::MD5.hexdigest(@path)}"
    end

  end
end