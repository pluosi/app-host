class AddUniqKeyToPkg < ActiveRecord::Migration[5.1]
  def change
    add_column :pkgs, :uniq_key, :string
  end
end
