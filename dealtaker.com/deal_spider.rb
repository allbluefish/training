require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"
require 'net/http'
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
      links = get_html_deal_link(deals_link, 'div.offerText a.DTOff')

      links.each do |l|
        puts l
      end
    end
  end

  # 抓取一个页面上的所有货物
  # @param deals_link [String]
  # @param css [String]
  def get_html_deal_link(deals_link, css)
    links = Array.new
    doc = Nokogiri::HTML(open(deals_link))
    doc.css(css).each do |link|
      links.push(link['href'])
    end
    links
  end

  def get_node(doc, xpath)
    items = Array.new
    doc.xpath(xpath).each do |link|
      items.push(link)
    end
    items
  end

  def get_rss_deal(doc)

    #uri = 'http://www.dealtaker.com/feed/offer/order-newest/limit-20/'
    #doc = Nokogiri::HTML(open(ui))

    #file = File.open("#{File.dirname(__FILE__)}/deals.rss.html")
    #doc = Nokogiri::XML(file)

    items = get_node(doc, '//item')

    items.each do |item|

      description = item.xpath('description').inner_html

      store_name = description.split('Store:</b>')[1].split(/<br\s*\/?>/i)[0].strip
      store = Store.find_by_name(store_name)
      Store.new(:name => store_name).save if store.nil?
      store = Store.find_by_name(store_name)

      description_doc = Nokogiri::HTML.parse(description)
      img = description_doc.xpath('//img/@src').inner_text

      title = item.xpath('title').inner_text
      pub_date = item.xpath('pubDate').inner_text
      date = Time.parse(pub_date)
      link = item.xpath('link').inner_text.split('?')[0]

      deal = Deal.new(:title => title, :description => description, :pubDate => date, :location => link, :image => img)
      store.deals << deal
      store.save

    end

  end

  def get_rss_category

    file = File.open("#{File.dirname(__FILE__)}/deals.rss.html")
    doc = Nokogiri::XML(file)

    items = get_node(doc, '//item')

    items.each do |item|
      categories = item.xpath('category')
      categories.each do |category|
        puts category.inner_html.strip
      end
    end
  end

  def get_last_date(doc,date_label,current_time)
    dates = get_node(doc, "//item/#{date_label}")
    current_time > Time.parse(dates.first.inner_text)
  end

  def is_old_rss
    file = File.open("#{File.dirname(__FILE__)}/deals.rss.html")
    doc = Nokogiri::XML(file)
    publish_date = doc.xpath('//lastBuildDate').inner_text
    s = Time.parse(publish_date)

    puts s
  end


end

