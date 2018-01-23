class AddSpiderStatusToHouse < ActiveRecord::Migration
  def change
    add_column :houses, :spider_status, :integer, default:0
  end
end
