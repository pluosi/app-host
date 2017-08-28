# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  role            :string           default("user")
#  password_digest :string
#  remember_token  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  
  has_many :apps, :dependent => :destroy
  has_many :plats, :dependent => :destroy
  has_many :pkgs, :dependent => :destroy

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates_uniqueness_of :email, :allow_blank => false

  # validates_length_of :password, :minimum => 4

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :create_api_token

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

  def api_token!
    create_api_token && self.save
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def create_api_token
    self.api_token = User.encrypt(User.new_remember_token)
  end

end