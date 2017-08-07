class PlatsController < ApplicationController
  before_action :set_app, only: [:new, :create, :edit, :update, :destroy, :comments]
  before_action :set_plat, only: [:show]

  def index
    @plats = Plat.all
  end

  def show
    @pkgs = @plat.pkgs
  end

  def new
    @plat = @app.plats.build
  end

  def create
    plat = Plat.create(plat_params)
    redirect_to plat_path plat
  end

  private
  # # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:app_id])
  end
  
  def set_plat
    @plat = Plat.find(params[:id])
  end

  # # Never trust parameters from the scary internet, only allow the white list through.
  def plat_params
    params.require(:plat).permit(:name);
  end
end