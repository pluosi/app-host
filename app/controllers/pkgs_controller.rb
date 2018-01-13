class PkgsController < ApplicationController
  protect_from_forgery :except => [:api_create]

  before_action :set_plat, only: [:new,:create]


  def show
    @pkg = Pkg.find params[:id]
    history = Pkg.where("id < ?",@pkg.id).limit(20).where(plat_id:@pkg.plat_id).id_desc
    history.each do |e|
      @history ||= {}
      time_str = e.created_at.strftime("%Y-%m-%d")
      @history[time_str] ||= []
      @history[time_str] << e
    end
    unless (browser.platform.ios? && !@pkg.ios?) || (browser.platform.android? && !@pkg.android?)
      @download_url = (browser.platform.android? || browser.platform.ios?) ? @pkg.install_url : @pkg.download_url
    end
  end

  #ios install manifest file
  def manifest
    @pkg = Pkg.find params[:id]
    stream = render_to_string(:template=>"pkgs/manifest.xml" )  
    render xml: stream
  end

  def new
    @pkg = @plat.pkgs.build
  end

  def create
    authorize!(:create, Pkg)
    pkg = Pkg.new(pkg_params.merge(user_id:current_user.id))
    pkg.app_id = pkg.plat.app_id

    unless pkg_params[:file_nick_name].present?
      pkg.file_nick_name = pkg.display_file_name
    end

    @plat.validate_pkg(pkg)
    
    pkg.save
    redirect_to pkg_path pkg
  rescue => e
    redirect_to new_plat_pkg_path(@plat), :flash => { :error => e.message }
  end

  def destroy
    pkg = Pkg.find params[:id]
    authorize!(:destroy, pkg)
    pkg.destroy!
    redirect_to app_plat_path pkg.app, pkg.plat
  end


  #api 提交包
  #params
  # - api_token: 授权 token  
  # - plat_id: 要传到的渠道
  # - pkg: 文件
  def api_create
    
    api_token = params[:token]

    user = User.find_by(api_token: api_token)
    unless user
      raise "401 Unauthorized"
    end

    plat = Plat.find params[:plat_id]

    pkg = Pkg.new({file:params[:file], user_id:user.id, plat_id:plat.id, file_nick_name:params[:file_nick_name]})
    pkg.app_id = pkg.plat.app_id

    unless params[:file_nick_name].present?
      pkg.file_nick_name = pkg.display_file_name
    end

    plat.validate_pkg(pkg)
    
    pkg.save!

    render json: pkg.to_json

  rescue => e
    render json: {error: "#{e.message}"}
  end


  private
  
  def set_plat
    @plat = Plat.find(params[:plat_id])
  end

  # # Never trust parameters from the scary internet, only allow the white list through.
  def pkg_params
    params.require(:pkg).permit(:file,:plat_id,:file_nick_name)
  end
end