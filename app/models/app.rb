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
#  user_id        :integer
#

class App < ApplicationRecord

  has_many :pkgs, :dependent => :destroy
  has_many :plats, :dependent => :destroy

  belongs_to :user

  validates_uniqueness_of :name, :allow_blank => false
  validates_presence_of :user_id

  def icon
    pkgs.last&.icon
  end
  
end
