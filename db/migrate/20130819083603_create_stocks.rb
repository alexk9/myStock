class CreateStocks < ActiveRecord::Migration
  def change
    #create_table :stocks,{id:false,:primary_key => :stock_code} do |t|
    #  t.string :company_name
    #  #t.string :stock_code
    #  t.string :biz_category
    #  t.string :market
    #  t.timestamps
    #end
    execute """
    CREATE TABLE stocks (
         stock_code CHAR(6),
         company_name VARCHAR(255),
         biz_category VARCHAR(255),
         market VARCHAR(255),
         created_at  DATETIME,
         updated_at  DATETIME,
         PRIMARY KEY (stock_code)
    );
    """
  end
end
