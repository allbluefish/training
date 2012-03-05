require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"

class TestSpider

  #doc = Nokogiri::HTML.parse(open('http://www.google.com.hk/search?q=tenderlove'), nil, "UTF-8")
  #doc = Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", Nokogiri::HTML(open(url)))

  #doc.css('h3').each do |link|
  #  puts "########################"
  #  puts link.content
  #  #puts Iconv.iconv("GBK//IGNORE", "UTF-8//IGNORE", link.content)
  #end

  #doc.xpath('//h3/a[@class="l"]').each do |link|
  #  puts link.content
  #end

  #doc.search('h3.r a.l', '//h3/a[@class="l"]').each do |link|
  #  puts link.content
  #end

  # Print out each link using a CSS selector
  #doc.css('h3.r > a.l').each do |link|
  #  puts link.content
  #end

  #doc.css('div.couponCode a').each do |link|
  #  puts link['href']
  #end

  #doc.css('div.pagination a').each do |link|
  #  puts link['rel']
  #end



  def get_html_deal_link(css)
    file = File.new('D:\Ruby\project\myRuby\dealtaker.com\deals.html')
    doc = Nokogiri::HTML(file)
    doc.css(css).each do |link|
      puts link['href']
    end
  end

  def get_node(doc,xpath)
    items = Array.new
    doc.xpath(xpath).each do |link|
      items.push(link)
    end
    items
  end

  def get_rss_deal
    file = File.new('D:\Ruby\project\myRuby\dealtaker.com\deals.rss.html')
    doc = Nokogiri::XML(file)


    #doc.xpath('//item/title').each do |link|
    #  puts link.content
    #end

    items = get_node(doc,'//item')
    items.each do |item|
      a = item.xpath('title')
      puts a.inner_text
    end

    #get_node(doc,'//item/title')
    #get_node(doc,'//item/description')
  end

  mg = TestSpider.new
  #mg.get_html_deal_link('div.offerText a.DTOff')
  mg.get_rss_deal

end

