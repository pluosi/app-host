module PlatAble
  extend ActiveSupport::Concern

  def plat_ext_name
    PkgAdapter.config.adapters[plat_name][:ext_name]
  end

  def plat_des_name
    PkgAdapter.config.adapters[plat_name][:des]
  end

end