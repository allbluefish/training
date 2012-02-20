require 'active_record'

class Deal < ActiveRecord::Base
  set_table_name "deal"
  belongs_to :store
end