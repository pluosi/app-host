class AddUserIdToEnties < ActiveRecord::Migration[5.1]
  def change
    add_column :apps, :user_id, :integer
    add_column :plats, :user_id, :integer
    add_column :pkgs, :user_id, :integer
  end
end
