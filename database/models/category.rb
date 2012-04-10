require 'active_record'

class Category < ActiveRecord::Base
  self.table_name = "categories"
  has_many :deal_categoryships
  has_many :deals, :through => :deal_categoryships
end
