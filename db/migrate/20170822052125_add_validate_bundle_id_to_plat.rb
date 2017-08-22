class AddValidateBundleIdToPlat < ActiveRecord::Migration[5.1]
  def change
    add_column :plats, :bundle_id, :string
  end
end
