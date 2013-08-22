class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices,{id:false} do |t|
      t.string :std_ymd
      t.string :stock_code, references: [:Stock, :stock_code]
      t.integer :end_price
      t.integer :comp_last
      t.string  :comp_dir     #상한,상승,하락,하한
      t.integer :start_price
      t.integer :high_price
      t.integer :low_price
      t.integer :amount

      t.timestamps
    end
  end
end



