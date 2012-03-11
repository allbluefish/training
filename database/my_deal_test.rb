require 'rubygems'
require 'active_record'
require 'yaml'
require '../dealtaker.com/deal_spider'

class DataBaseTest
  db_config = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(db_config)

  file = File.open("#{File.dirname(__FILE__)}/../dealtaker.com/deals.rss.html")
  doc = Nokogiri::XML(file)

  deal_spider = DealsSpider.new

  deal_spider.get_rss_deal(doc)

  #deal_spider.test_category_deal

  #deal_spider.is_old_rss

  #deal_spider.get_rss_category

  #deal_spider.get_last_deal

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

  #s = Time.parse('Tue, 14 Feb 2012 23:59:00 -0600')

  #date = s.strftime("%Y-%m-%d")

  #puts date
end
