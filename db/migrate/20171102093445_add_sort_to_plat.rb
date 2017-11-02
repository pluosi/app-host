class AddSortToPlat < ActiveRecord::Migration[5.1]
  def change
    add_column :plats, :sort, :integer, default:0
  end
end
