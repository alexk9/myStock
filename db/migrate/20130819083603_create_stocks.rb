class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks,{id:false,:primary_key => :stock_code} do |t|
      t.string :company_name
      t.string :stock_code
      t.string :biz_category
      t.string :market
      t.timestamps
    end
  end
end
