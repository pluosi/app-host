# == Schema Information
#
# Table name: plats
#
#  id             :integer          not null, primary key
#  name           :string
#  plat_name      :string
#  app_id         :integer
#  pkg_name       :string
#  packages_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  bundle_id      :string
#  pkg_uniq       :boolean          default(TRUE)
#  user_id        :integer
#

class Plat < ApplicationRecord
  acts_as_paranoid
  
  has_many :pkgs, :dependent => :destroy
  
  belongs_to :app
  belongs_to :user

  validates_presence_of :user_id

  enum plat_name: {
    ios: 'ios',
    android: 'android'
  }

  def plat_ext_name
    PkgAdapter.config.adapters[plat_name][:ext_name]
  end
  
end
