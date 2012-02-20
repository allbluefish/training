require 'active_record'

class Store < ActiveRecord::Base
  set_table_name "store"
  has_many :deals
end