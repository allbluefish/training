require 'active_record'

class Store < ActiveRecord::Base
  self.table_name = "store"
  has_many :deals
end