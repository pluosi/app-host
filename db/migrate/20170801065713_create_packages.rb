class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|

      t.integer :app_id

      t.string :name
      t.string :icon
      
      t.string :plat
      t.string :ident
      
      t.string :version
      t.string :build

      # t.string :

      t.timestamps
    end
  end
end
