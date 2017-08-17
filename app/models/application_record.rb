class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  scope :desc, ->(key){order("#{key} DESC")}
  scope :id_desc, ->{desc(:id)}

end
