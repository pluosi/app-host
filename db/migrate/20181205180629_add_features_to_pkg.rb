class AddFeaturesToPkg < ActiveRecord::Migration[5.1]
  def change
    add_column :pkgs, :features, :string
  end
end
