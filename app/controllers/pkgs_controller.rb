class PkgsController < ApplicationController
  before_action :set_plat, only: [:show,:new,:create]


  def show
    @pkg = Pkg.find params[:id]
  end

  def new
    @pkg = @plat.pkgs.build
  end

  def create
    pkg = Pkg.new(pkg_params)
    
    if @plat.bundle_id.present? && pkg.ident != @plat.bundle_id
      raise "Pkg Bundle Id Validation Fail"
    end

    if pkg.plat_name != @plat.plat_name
      raise "Pkg Plat Validation Fail"
    end

    if @plat.pkg_uniq? && !pkg.uniq?
      raise "Pkg Uniq Validation Fail"
    end
    
    pkg.save
    redirect_to plat_pkg_path @plat, pkg
  rescue => e
    redirect_to new_plat_pkg_path(@plat), :flash => { :error => e.message }
  end

  def destroy
    pkg = Pkg.find params[:id]
    pkg.destroy!
    redirect_to app_plat_path pkg.app, pkg.plat
  end


  private
  
  def set_plat
    @plat = Plat.find(params[:plat_id])
  end

  # # Never trust parameters from the scary internet, only allow the white list through.
  def pkg_params
    params.require(:pkg).permit(:file,:app_id,:plat_id)
  end
end