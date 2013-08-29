class HighestAnalMaster < ActiveRecord::Base
  self.primary_keys = :stock_code

  belongs_to :stock, :foreign_key => "stock_code"

end
