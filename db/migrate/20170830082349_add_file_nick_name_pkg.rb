class AddFileNickNamePkg < ActiveRecord::Migration[5.1]
  def up
    add_column :pkgs, :file_nick_name, :string

    Pkg.all.each do |pkg|
      pkg.update_columns(file_nick_name: pkg.display_file_name)
    end
  end

  def down
    remove_column :pkgs, :file_nick_name
  end
end
