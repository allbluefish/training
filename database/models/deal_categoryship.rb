require 'active_record'

class DealCategoryship < ActiveRecord::Base
  self.table_name = "deal_categoryships"
  belongs_to :deal
  belongs_to :category
end