class CreateWorkingDates < ActiveRecord::Migration
  def change
    if @connection.instance_variable_get(:@config)[:adapter] == 'mysql2'
      create_table(:working_dates,{:id=>false, :primary_key => 'std_ymd'}) do |t|
        t.column :std_ymd, 'char(8)'

        t.timestamps
      end
      execute "alter table working_dates ADD PRIMARY KEY(std_ymd);"
    elsif @connection.instance_variable_get(:@config)[:adapter] == 'sqlite3'
      execute """
      CREATE TABLE working_dates (
           std_ymd CHAR(8),
           created_at  DATETIME,
           updated_at  DATETIME,
           PRIMARY KEY (std_ymd)
      );
      """
    end
  end
end
