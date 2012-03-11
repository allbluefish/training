require 'active_record'

class DealCategoryship < ActiveRecord::Base
  self.table_name = "deal_categoryship"
  belongs_to :deal
  belongs_to :category
end