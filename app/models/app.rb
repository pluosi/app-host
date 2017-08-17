# == Schema Information
#
# Table name: apps
#
#  id             :integer          not null, primary key
#  name           :string
#  icon           :string
#  plants         :string
#  last_version   :string
#  last_pkg_size  :integer
#  last_pkg_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  desc           :string
#  channels_count :integer          default(0)
#  palts_count    :integer          default(0)
#  packages_count :integer          default(0)
#

class App < ApplicationRecord

  has_many :pkgs
  has_many :plats

  validates_uniqueness_of :name, :allow_blank => false
  
end
