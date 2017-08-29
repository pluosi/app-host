module PlatsHelper
  
  def pkg_selectable_map
    PkgAdapter.config.adapters.map{|k,v|{v[:des] => k}}.inject(:merge)
  end
end

