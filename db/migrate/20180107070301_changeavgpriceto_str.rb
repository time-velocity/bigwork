class ChangeavgpricetoStr < ActiveRecord::Migration
  def change
    remove_column :houses, :average_price
    add_column :houses, :average_price, :string
  end
end
