class PlatsController < ApplicationController
  before_action :set_app, only: [:index, :show, :new, :create, :destroy, :api_sort]
  before_action :set_plat, only: [:show,:destroy,:update,:edit]

  def index
    @plats = Plat.where(app_id:params[:app_id])
    if @plats.present?
      redirect_to app_plat_path @plats.first.app, @plats.first
    else
      redirect_to new_app_plat_path @app
    end
  end

  def show
    @pkgs = @plat.pkgs.id_desc.page(params[:page]).per(params[:per])
    @plats = Plat.where(app_id:params[:app_id]).order(:sort,:id)
  end

  def new
    @plat = @app.plats.build
  end

  def create
    authorize!(:create, Plat)
    plat = Plat.create(plat_params.merge(user_id:current_user.id,sort:Plat.count))
    redirect_to app_plat_path @app, plat
  end

  def destroy
    authorize!(:destroy, @plat)
    @plat.destroy!
    @plats = Plat.where(app_id:params[:app_id])
    if @plats.first
      redirect_to app_plat_path @plats.first.app, @plats.first
    else
      redirect_to new_app_plat_path @app
    end
  end

  def edit
    render "new"
  end

  def update
    authorize!(:update, @plat)
    @plat.update(plat_params)
    redirect_to app_plat_path @plat.app, @plat
  end

  def api_sort
    authorize!(:update, @plat)
    ids = params[:ids].split(",").map(&:to_i)
    plats = Plat.where(id:ids)
    map = plats.map { |e| [e.id,e] }.to_h
    ids.each_with_index do |id,index|
      plat = map[id]
      plat.update_column(:sort,index)
    end
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
    params.require(:plat).permit(:name,:app_id,:plat_name,:bundle_id,:pkg_uniq);
  end
end