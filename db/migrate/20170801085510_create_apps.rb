class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :icon
      t.string :plants
      t.string :last_version
      t.integer :last_pkg_size
      t.integer :last_pkg_id

      t.timestamps
    end
  end
end
