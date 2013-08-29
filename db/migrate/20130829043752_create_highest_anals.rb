class CreateHighestAnals < ActiveRecord::Migration
  def change
    if @connection.instance_variable_get(:@config)[:adapter] == 'mysql2'
      create_table(:highest_anals,{:id=>false}) do |t|
          t.column :stock_code, 'char(8)', :null=>false
          t.column :stock_code_seq, 'INTEGER', :null=>false
          t.column :first_date,  'char(10)'
          t.column :second_date, 'char(10)'

          t.timestamps
        end
      execute "alter table highest_anals ADD PRIMARY KEY(stock_code,stock_code_seq);"
    elsif  @connection.instance_variable_get(:@config)[:adapter] == 'sqlite3'
      execute """
      CREATE TABLE highest_anals (
           stock_code       CHAR(6) NOT NULL,
           stock_code_seq   INTEGER NOT NULL,
           first_date       CHAR(10),
           second_date      CHAR(10),
           created_at  DATETIME,
           updated_at  DATETIME,
           PRIMARY KEY (stock_code,stock_code_seq)
      );
      """
    end
  end

end
