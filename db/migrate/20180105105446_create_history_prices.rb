class CreateHistoryPrices < ActiveRecord::Migration
  def change
    create_table :history_prices do |t|
      t.date :date
      t.integer :price
      t.references :house, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
