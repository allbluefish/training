require 'rubygems'
require 'active_record'
require 'yaml'
require '../dealtaker.com/dealSpider'

class DataBaseTest
  dbconfig = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)

  deal_spider = DealsSpider.new

  deal_spider.get_xml_deal_link

  #deals = deal_spider.get_xml_deal_link
  #
  #deals.each do |d|
  #  d.save
  #end

  #store = Store.where( :name => 'apple')
  #
  #store1 = Store.find_by_name('apple')
  #
  #puts store[0].id
  #puts store1.id
  #
  #puts Deal.count

end
