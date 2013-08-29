class CreateHighestAnalMasters < ActiveRecord::Migration
  def change
    if @connection.instance_variable_get(:@config)[:adapter] == 'mysql2'
      create_table( :highest_anal_masters,{:id=>false}) do |t|
        t.column :stock_code,   'CHAR(6)', :null => false
        t.column :highest_cnt, 'INTEGER'
        t.column :highest_pair_cnt,  'integer'
        t.column :up_cnt, 'INTEGER'
        t.column :up_pair_cnt, 'INTEGER'
        t.column :down_cnt, 'INTEGER'
        t.column :down_pair_cnt, 'INTEGER'
        t.column :lowest_cnt, 'INTEGER'
        t.column :lowest_pair_cnt, 'INTEGER'
      end
      execute "alter table highest_anal_masters ADD PRIMARY KEY(stock_code);"
    elsif  @connection.instance_variable_get(:@config)[:adapter] == 'sqlite3'
      execute """
      CREATE TABLE highest_anal_masters (
           stock_code       CHAR(6) NOT NULL,
           highest_cnt      INTEGER,
           highest_pair_cnt INTEGER,
           up_cnt           INTEGER,
           up_pair_cnt      INTEGER,
           down_cnt         INTEGER,
           down_pair_cnt    INTEGER,
           lowest_cnt       INTEGER,
           lowest_pair_cnt  INTEGER,
           created_at  DATETIME,
           updated_at  DATETIME,
           PRIMARY KEY (stock_code)
      );
      """
    end

  end
end
