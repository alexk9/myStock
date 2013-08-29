require 'composite_primary_keys'

class Stock < ActiveRecord::Base
  self.primary_keys = :stock_code
  has_many :prices,
           :foreign_key => :stock_code
  has_many :highest_anals,
           :foreign_key => :stock_code
  has_one :highest_anal_master,
          :foreign_key => :stock_code
end
