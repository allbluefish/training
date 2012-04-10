require 'active_record'

class Store < ActiveRecord::Base
  self.table_name = "stores"
  has_many :deals
end