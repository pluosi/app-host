# == Schema Information
#
# Table name: pkgs
#
#  id         :integer          not null, primary key
#  app_id     :integer
#  name       :string
#  icon       :string
#  plat       :string
#  ident      :string
#  version    :string
#  build      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plat_id    :integer
#  file       :string
#  size       :integer          default(0)
#

class Pkg < ApplicationRecord

  attr_accessor :app_icon

  belongs_to :app

  validates_presence_of :file

  mount_uploader :icon, IconUploader
  mount_uploader :file, PkgUploader

  enum plat: {
    ios: 'ios',
    android: 'android'
  }

  after_create :save_icon

  def initialize pars
    super pars
    parsing
  end

  def parsing
    if file.path
      parser = PkgAdapter.pkg_adapter(file.path)
      self.name = parser.app_name
      self.app_icon = parser.app_icon
      self.version = parser.app_version
      self.build = parser.app_build
      self.size = parser.app_size
      self.ident = parser.app_ident
      self.plat = parser.plat
    end
  end

  def save_icon
    if app_icon
      self.icon.store!(File.new(app_icon))
      self.save  
    end
  end
  
  
end
