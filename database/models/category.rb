require 'active_record'

class Category < ActiveRecord::Base
  self.table_name = "category"
  has_many :deal_categoryships
  has_many :deals, :through => :deal_categoryships
end
