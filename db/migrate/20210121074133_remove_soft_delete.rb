class RemoveSoftDelete < ActiveRecord::Migration[5.2]
  def change
    App.where.not(deleted_at:nil).destroy_all
    Plat.where.not(deleted_at:nil).destroy_all
    Pkg.where.not(deleted_at:nil).destroy_all
    User.where.not(deleted_at:nil).destroy_all
  end
end
