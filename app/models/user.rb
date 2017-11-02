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
#  api_token       :string
#  deleted_at      :datetime
#

class User < ApplicationRecord

  acts_as_paranoid
  
  has_secure_password
  
  has_many :apps, :dependent => :destroy
  has_many :plats, :dependent => :destroy
  has_many :pkgs, :dependent => :destroy

  MIN_PWD_LEN = 4

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates_uniqueness_of :email, :allow_blank => false

  validates :password, presence: true, length: { minimum: MIN_PWD_LEN }, :on => :create

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :create_api_token

  enum role: {
    admin: 'admin',
    editor: 'editor',
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
