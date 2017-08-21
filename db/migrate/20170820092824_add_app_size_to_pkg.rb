class AddAppSizeToPkg < ActiveRecord::Migration[5.1]
  def change
    add_column :pkgs, :size, :integer, default:0
  end
end
