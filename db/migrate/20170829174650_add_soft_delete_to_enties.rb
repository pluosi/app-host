class AddSoftDeleteToEnties < ActiveRecord::Migration[5.1]
  def change
    add_column :apps, :deleted_at, :datetime
    add_index :apps, :deleted_at

    add_column :plats, :deleted_at, :datetime
    add_index :plats, :deleted_at

    add_column :pkgs, :deleted_at, :datetime
    add_index :pkgs, :deleted_at
    
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
