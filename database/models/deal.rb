require 'active_record'

class Deal < ActiveRecord::Base
  self.table_name = "deals"
  belongs_to :store
  has_many :deal_categoryships
  has_many :categories, :through => :deal_categoryships
end