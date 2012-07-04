# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'

class TestSpider

  def get_description(doc)
    a1 = doc.css('div.rssBullet ul.rssCat li.rssCatList a')
    a2 = doc.css('div.rssBullet ul.rssCat li.rssCatList a.noline')
    a = a1-a2
    a.each do |tag_a|
      p tag_a['href']
      p tag_a.inner_text
    end

end

#file = File.open("#{File.dirname(__FILE__)}/../newegg.com/rss.html")
#doc = Nokogiri::XML.parse(file)

uri = 'http://www.newegg.com/RSS/Index.aspx'
doc = Nokogiri::HTML(open(uri))

test = TestSpider.new
test.get_description(doc)

end

