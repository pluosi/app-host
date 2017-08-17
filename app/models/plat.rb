# == Schema Information
#
# Table name: plats
#
#  id             :integer          not null, primary key
#  name           :string
#  plat           :string
#  app_id         :integer
#  pkg_name       :string
#  packages_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Plat < ApplicationRecord
  has_many :pkgs
end
