require 'rubygems'
require 'nokogiri'

class TestSpider
  doc = Nokogiri::HTML.parse(File.new('D:\Ruby\project\myRuby\test.html'))

####
# Search for nodes by css
#  doc.css('p > a').each do |a_tag|
#    puts a_tag.content
#  end

  doc.css('div.couponCode a').each do |a_tag|
    puts a_tag.content
  end


####
# Search for nodes by xpath
#  doc.xpath('//p/a').each do |a_tag|
#    puts a_tag.content
#  end

####
# Or mix and match.
#  doc.search('//p/a', 'p > a').each do |a_tag|
#    puts a_tag.content
#  end

###
# Find attributes and their values
  a = doc.search('a').first['href']
  b = doc.search('a').last['href']
  puts a,b
  puts "############"
end