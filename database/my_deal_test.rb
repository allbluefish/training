require 'rubygems'
require 'active_record'
require 'yaml'
require '../dealtaker.com/dealSpider'

class DataBaseTest
  dbconfig = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)

  deal_spider = DealsSpider.new

  deals = deal_spider.get_xml_deal_link

  deals.each do |d|
    d.save
  end

  puts Deal.count

end
