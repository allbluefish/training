require 'active_record'

class Deal < ActiveRecord::Base
  self.table_name = "deal"
  belongs_to :store
  has_many :deal_categoryships
  has_many :categories, :through => :deal_categoryships
end