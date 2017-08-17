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
    pkg.name = "unset"

    pkg.save

    redirect_to plat_pkg_path @plat, pkg
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