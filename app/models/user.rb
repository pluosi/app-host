class User < ApplicationRecord
  has_secure_password
  
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  enum role: {
    admin: 'admin',
    user: 'user'
  }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
