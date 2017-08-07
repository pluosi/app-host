class RenamePackeagesToPkgs < ActiveRecord::Migration[5.1]
  def change
    rename_table :packages, :pkgs
  end
end