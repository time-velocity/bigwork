class AddLocalRoughCastAndChangeAreaType < ActiveRecord::Migration
  def change
    add_column :houses, :local ,:string
    add_column :houses, :roughcast, :boolean
    remove_column :houses, :area
    add_column :houses, :area, :string
  end
end
