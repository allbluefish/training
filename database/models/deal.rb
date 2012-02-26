require 'active_record'

class Deal < ActiveRecord::Base
  self.table_name = "deal"
  belongs_to :store
end