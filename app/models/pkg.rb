# == Schema Information
#
# Table name: packages
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
#

class Pkg < ApplicationRecord

  belongs_to :app
  
end
