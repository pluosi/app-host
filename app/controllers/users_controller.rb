class UsersController < ApplicationController

  def index
    @users = User.id_desc.page(params[:page]).per(params[:per])
  end

  def new
    unless User.admin.exists?
      @init_admin = true
    end
    @user = User.admin.new
  end

  def create
    user = User.new user_params
    if !User.admin.exists? || authorize!(:create, user)
      unless user.save
        flash[:error] = user.errors.full_messages
        redirect_to new_user_path and return
      end
    end
    redirect_to root_path
  end

  def show
    unless signed_in? && params[:id].to_i == current_user.id
      redirect_to root_path
    end
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find_by_id params[:id]
  end

  def update

    if current_user.admin? || params[:id].to_i == current_user.id
      @user = User.find_by_id params[:id]
    else
      raise "无权操作"
    end
    
    @user.password = params[:user][:password]
    if params[:user][:password].length < User::MIN_PWD_LEN
      flash[:error] = "密码少于#{User::MIN_PWD_LEN}位"
      redirect_to edit_user_path(@user) and return
    end
    if @user.save
      flash[:alert] = '修改成功'  
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    if current_user.admin? && params[:id].to_i != current_user.id
      @user = User.find_by_id params[:id]
      @user.destroy!
      redirect_to users_path
    else
      raise "无权操作"
    end
  end

  def api_token
  end

  def refresh_api_token
    current_user.api_token!
    redirect_to api_token_user_path(current_user)
  end

  private

  # # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email,:role,:password);
  end
end