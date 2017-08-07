class AddPlatIdToPkg < ActiveRecord::Migration[5.1]
  def change
    add_column :pkgs, :plat_id, :integer
  end
end
