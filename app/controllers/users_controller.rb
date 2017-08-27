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
      user.save
    end
    redirect_to root_path
  end

  private

  # # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email,:role,:password);
  end
end