class HighestAnal < ActiveRecord::Base
  self.primary_keys= :stock_code, :stock_code_seq
  belongs_to :stock, :foreign_key => "stock_code"
  belongs_to :highest_anal_master, :foreign_key => "stock_code"

end
