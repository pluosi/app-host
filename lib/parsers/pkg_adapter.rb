module PkgAdapter

  extend self

  def pkg_adapter(path)
    ext = File.extname("#{path}").gsub('.','')
    unless ext.present?
      raise "get ext name fail"
    end
    ext = ext.downcase
    adapter = config.adapter_for_ext(ext)
    if adapter
      "PkgAdapter::#{adapter}".constantize.new path  
    else
      raise "can not find adapter #{ext}"
    end
  end

  def config
    $pkg_adapter_config ||= PkgAdapter::Config.new
  end

  def setup
    yield(config)
  end

  def adapter_exts
    config.adapters.map{ |k,v| v[:ext_name] }
  end

end