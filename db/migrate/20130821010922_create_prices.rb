class CreatePrices < ActiveRecord::Migration
  def change
    #create_table :prices,{id:false } do |t|
    #  t.string :std_ymd                                        ,:null => false
    #  t.string :stock_code, references: [:Stock, :stock_code]  ,:null => false
    #  t.integer :end_price
    #  t.integer :comp_last
    #  t.string  :comp_dir     #상한,상승,하락,하한
    #  t.integer :start_price
    #  t.integer :high_price
    #  t.integer :low_price
    #  t.integer :amount
    #
    #  t.timestamps
    #end
    #
    #add_index :prices, [:std_ymd, :stock_code]
    execute """
    CREATE TABLE prices (
         std_ymd CHAR(8),
         stock_code CHAR(6),
         end_price  BIGINT,
         comp_last  BIGINT,
         comp_dir   VARCHAR(10),
         start_price BIGINT,
         high_price  BIGINT,
         low_price   BIGINT,
         amount      BIGINT,
         created_at  DATETIME,
         updated_at  DATETIME,
         PRIMARY KEY (std_ymd, stock_code)
    );
    """
  end
end



