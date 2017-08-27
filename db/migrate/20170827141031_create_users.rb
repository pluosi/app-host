class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :role, default: 'user'

      t.string :password_digest

      t.string :remember_token

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :remember_token
  end
end
