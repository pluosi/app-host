class CreatePlats < ActiveRecord::Migration[5.1]
  def change
    create_table :plats do |t|
      t.string :name
      t.string :plat
      t.integer :app_id
      t.string :pkg_name

      t.integer :packages_count, default:0

      t.timestamps
    end
  end
end
