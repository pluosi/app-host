module UserSign
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !self.current_user.nil? 
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    unless @current_user
      remember_token = cookies[:remember_token]
      @current_user = User.find_by(remember_token: User.encrypt(remember_token)) if remember_token
    end
    @current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end