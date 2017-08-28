class UsersController < ApplicationController
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
    @user = current_user
  end

  def update
    @user = current_user
    @user.password = params[:user][:password]
    if @user.save
      flash[:alert] = '修改成功'  
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to edit_user_path(@user)
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