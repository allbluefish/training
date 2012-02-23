require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"
require "../database/models/deal"
require "../database/models/store"

class DealsSpider


  def get_count doc, css, key
    html = doc.css(css).last[key]
    html.split('_')[1]
  end

  # 根据总页数和分页地址抓取单个货物的链接
  # @param page_count [int]
  # @param link [String]
  def get_deals_link(page_count, link)
    for i in 1..page_count.to_i
      deals_link = "#{link}#{i}/"
      links = get_html_deal_link(deals_link,'div.offerText a.DTOff')

      links.each do |l|
        puts l
      end
    end
  end

  # 抓取一个页面上的所有货物
  # @param deals_link [String]
  # @param css [String]
  def get_html_deal_link(deals_link,css)
    links = Array.new
    doc = Nokogiri::HTML(open(deals_link))
    doc.css(css).each do |link|
      links.push(link['href'])
    end
    links
  end

  def get_node(doc,xpath)
    items = Array.new
    doc.xpath(xpath).each do |link|
      items.push(link)
    end
    items
  end

  def get_xml_deal_link

    file = File.new('D:\Ruby\project\myRuby\dealtaker.com\deals.rss.html')
    doc = Nokogiri::XML(file)

    items = get_node(doc,'//item')

    items.each do |item|
      title = item.xpath('title').inner_text

      description = item.xpath('description').inner_html

      store_name = description.split('Store:</b>')[1].split(/<br\s*\/?>/i)[0].strip
      store = Store.find_by_name(store_name)
      Store.new(:name => store_name).save if store.nil?
      store = Store.find_by_name(store_name)

      pub_date = item.xpath('pubDate').inner_text
      date = Time.parse(pub_date)

      deal = Deal.new(:title => title, :description => description, :pubDate => date)
      store.deals << deal
      store.save
      #deal.save

    end

  end


  #mg = DealsSpider.new
  #count = mg.get_count(doc, 'div.pagination a', 'rel')
  #mg.get_deals_link(3, 'http://www.dealtaker.com/deals/#!/view-list/page-/')


end

