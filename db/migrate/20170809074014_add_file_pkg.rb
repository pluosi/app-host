class AddFilePkg < ActiveRecord::Migration[5.1]
  def change
    add_column :pkgs, :file, :string
  end
end
