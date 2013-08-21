require 'composite_primary_keys'

class Price < ActiveRecord::Base
  self.primary_keys = :stock_code, :std_ymd
  belongs_to :stock, :foreign_key => :stock_code

end
