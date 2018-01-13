# == Schema Information
#
# Table name: pkgs
#
#  id             :integer          not null, primary key
#  app_id         :integer
#  name           :string
#  icon           :string
#  plat_name      :string
#  bundle_id      :string
#  version        :string
#  build          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  plat_id        :integer
#  file           :string
#  size           :integer          default(0)
#  uniq_key       :string
#  user_id        :integer
#  deleted_at     :datetime
#  file_nick_name :string
#

class Pkg < ApplicationRecord
  acts_as_paranoid

  attr_accessor :app_icon
  include PlatAble

  belongs_to :app
  belongs_to :plat
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :file, :file_nick_name

  mount_uploader :icon, IconUploader
  mount_uploader :file, PkgUploader

  enum plat_name: {
    ios: 'ios',
    android: 'android'
  }

  after_create :save_icon

  def initialize pars
    super pars
    parsing
  end

  def uniq?
    !self.class.where({plat_id:plat_id,self.uniq_key.to_sym => self[self.uniq_key.to_sym]}).exists?
  end

  def size_mb
   '%.1f' % (size / (1024*1024.0))
  end

  def parsing
    if file.path
      self.name = parser.app_name
      self.app_icon = parser.app_icon
      self.version = parser.app_version
      self.build = parser.app_build
      self.size = parser.app_size
      self.bundle_id = parser.app_bundle_id
      self.plat_name = parser.plat
      self.uniq_key = parser.app_uniq_key
    end
  end

  def parser
    @parser ||= PkgAdapter.pkg_adapter(file.path)
  end

  def save_icon
    if app_icon
      self.icon.store!(File.new(app_icon))
      self.save  
    end
  end

  def ext_info
    @ext_info ||= parser.ext_info
  end

  def install_url
    if ios?
      "itms-services://?action=download-manifest&url=#{Settings.PROTOCOL}#{Settings.HOST}#{Rails.application.routes.url_helpers.manifest_pkg_path(self)}.plist"    
    else
      download_url
    end
  end

  def download_url
    "#{Settings.PROTOCOL}#{Settings.HOST}#{self.file}"
  end

  def display_file_name
    File.basename(file.path,".*")
  end
  
end
