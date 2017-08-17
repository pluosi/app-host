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
#

class Pkg < ApplicationRecord

  belongs_to :app

  validates_presence_of :file

  mount_uploader :icon, IconUploader
  mount_uploader :file, PkgUploader

  enum plat: {
    ios: 'ios',
    android: 'android'
  }

  after_create :parsing

  def parsing
    if file.path
      parser = PkgAdapter.pkg_adapter(file.path)
      self.name = parser.app_name
      self.icon.store!(File.new(parser.app_icon))
      self.version = parser.app_version
      self.build = parser.app_build
      self.save
    end
  end
  
  
end
