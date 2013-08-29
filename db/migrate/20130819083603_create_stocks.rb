class CreateStocks < ActiveRecord::Migration
  def change
    if @connection.instance_variable_get(:@config)[:adapter] == 'mysql2'
      create_table :stocks,{id:false,:primary_key => :stock_code} do |t|
        t.column :stock_code, 'char(6)'
        t.column :company_name, :string
        t.column :biz_category, :string
        t.column :market, :string
        t.timestamps
      end
      execute "alter table stocks ADD PRIMARY KEY(stock_code);"
    elsif @connection.instance_variable_get(:@config)[:adapter] == 'sqlite3'

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
end
