require 'composite_primary_keys'

class Stock < ActiveRecord::Base
  self.primary_keys = :stock_code
  has_many :prices, dependent: :destroy
end
