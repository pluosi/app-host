class AppsController < ApplicationController
  # before_action :set_app, only: [:show, :edit, :update, :destroy, :comments]

  def index
    
  end

  def show
  end

  def new
    @app = App.new
  end

  def create
    byebug
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @post = App.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def app_params
    params.require(:post).permit(:title,:image,:content,:contact,:copyright_origin,:copyright_wechat,:copyright_share,:copyright_anony);
  end
end