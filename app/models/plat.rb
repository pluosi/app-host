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
#

class Plat < ApplicationRecord
  has_many :pkgs, :dependent => :destroy
  belongs_to :app

  enum plat_name: {
    ios: 'ios',
    android: 'android'
  }
  
end
