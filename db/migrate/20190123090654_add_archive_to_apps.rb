class AddArchiveToApps < ActiveRecord::Migration[5.1]
  def change
    add_column :apps, :archived, :boolean, default:false
  end
end
