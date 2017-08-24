class RenamePlatToPlatName < ActiveRecord::Migration[5.1]
  def change
    rename_column :plats, :plat, :plat_name
    rename_column :pkgs, :plat, :plat_name
  end
end
