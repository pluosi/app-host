class AddExtInfoToPkgs < ActiveRecord::Migration[5.1]
  
  def up
    add_column :pkgs, :ext_info, :string

    Pkg.find_each do |pkg|
      pkg.parser.parse
      pkg.ext_info = pkg.parser.ext_info
      pkg.save
    end

  end

  def down
    remove_column :pkgs, :ext_info
  end
end
