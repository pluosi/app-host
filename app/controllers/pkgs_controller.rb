class PkgsController < ApplicationController
  before_action :set_plat, only: [:show,:new]


  def show
    @pkgs = @plat.pkgs
  end

  def new
    @pkg = @plat.pkgs.build
  end

  def create
    plat = Plat.create(plat_params)
    redirect_to plat_path plat
  end

  private
  
  def set_plat
    @plat = Plat.find(params[:plat_id])
  end

  # # Never trust parameters from the scary internet, only allow the white list through.
  def plat_params
    params.require(:plat).permit(:name);
  end
end