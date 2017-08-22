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

    def app_ident
    end

  end
end