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

  def bundle_id_reg
    if bundle_id.present?
      bundle_id_reg = bundle_id.gsub('.','\.').gsub('*','.*')
      bundle_id_reg = Regexp.new("^#{bundle_id_reg}")
    else
      /.*/
    end
  end

  def validate_pkg(pkg)
    if (bundle_id_reg =~ pkg.bundle_id) == nil
      raise "Bundle Id #{pkg.bundle_id} not match #{bundle_id}"
    end

    if pkg.plat_name != plat_name
      raise "Pkg Plat Validation Fail"
    end

    if pkg_uniq? && !pkg.uniq?
      raise "Pkg Uniq Validation Fail"
    end
  end

  
end
