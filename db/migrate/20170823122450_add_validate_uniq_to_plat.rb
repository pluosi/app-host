class AddValidateUniqToPlat < ActiveRecord::Migration[5.1]
  def change
    add_column :plats, :pkg_uniq, :boolean, default: true
  end
end
