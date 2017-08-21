module PkgAdapter
  extend self
  
  def pkg_adapter(path)
    ext = File.extname("#{path}").gsub('.','')
    unless ext.present?
      raise "get ext name fail"
    end
    clazz = ext.classify
    "PkgAdapter::#{clazz}".constantize.new path
  end
end