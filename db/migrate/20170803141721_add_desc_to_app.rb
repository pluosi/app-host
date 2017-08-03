class AddDescToApp < ActiveRecord::Migration[5.1]
  def change
    add_column :apps, :desc, :string
  end
end
