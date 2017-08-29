module PkgAdapter
  class Config
    attr_accessor :adapters
    def initialize
      self.adapters = {}
    end

    def adapter_for_ext(ext_name)
      plat_name = plat_name_with_ext(ext_name)
      adapter = adapters[plat_name]
      if adapter
        adapter[:class_name]
      else
        nil
      end
    end

    def adapter_for_plat(plat_name)
      adapter = adapters[plat_name]
      if adapter
        adapter[:class_name]
      else
        nil
      end
    end

    def plat_name_with_ext(ext_name)
      plat_name = nil
      adapters.each do |key,single|
        if single[:ext_name] == ext_name
          plat_name = key
          break
        end
      end
      plat_name
    end
  end
end