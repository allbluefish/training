# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"
require '../dealtaker.com/deal_spider'

class TestSpider

  #date = Time.parse('Thu, 12 Apr 2012 14:24:36 +0000')
  #now = Time.now
  #d = now.to_i - date.to_i
  #p d/(60*60*24)
  #
  #p 'blue'.start_with?('B', 'b')
  #p 'Aa'.to_a

  def save_deal(item)
    description = item.xpath('description').inner_html
    link = item.xpath('link').inner_text
    description_doc = Nokogiri::HTML.parse(description)
    # 剔除 description 中无用的字符串
    #button_text = description_doc.xpath('//a').inner_text

    #description_no_html = description.gsub(/<\/?.*?>/, '').gsub(button_text, '').gsub('&nbsp;', '')


    #store_name = description.split('Store:</b>')[1].split(/<br\s*\/?>/i)[0].strip
    title = item.xpath('title').inner_text
    title_split = title.split('-')
    title_name = title_split[1].strip

    store_name = title_split[0].strip
    store = get_store(store_name)

    #img = description_doc.xpath('//img/@src').inner_text

    pub_date = item.xpath('pubDate').inner_text
    date = Time.parse(pub_date, '%Y-%m-%d %H:%M:%S')
    link = item.xpath('link').inner_text.split('?')[0]

    deal = Deal.new(:title => title_name, :description_pure => description_no_html.strip, :description => description,
                    :pubDate => date, :location => link.strip, :image => img, :source => site)

    get_categories(deal, item)

    store.deals << deal
    store.save
  end


  def get_description(doc)
    items = DealsSpider.new.get_node(doc, '//item')
    items.each do |item|
      link = item.xpath('link').inner_html.gsub(/\n/, '')

      title = item.xpath('title').inner_text
      title_split = title.split('–')
      title_name = title_split[1].strip
      store_name = title_split[0].strip


      pub_date = item.xpath('pubDate').inner_text
      #date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      date = Time.parse(pub_date, '%Y-%m-%d %H:%M:%S')

      categories = item.xpath('category')
      categories.each do |c|
        category_name = c.inner_html.strip
        p category_name
        p '--------------------------'
      end

      #file = File.open(link)
      #doc = Nokogiri::XML.parse(open(rss_url))
      doc = Nokogiri::HTML.parse(open(link))
      get_image(doc)
      p '--------------------------'
      #p title_split
      p title_name
      p store_name
      p link
      p date

    end
  end

  def get_image(doc)
    img = doc.css('div.entry-image img/@src')
    des = doc.css('div#entry-content p')
    p img.inner_text
    p des.inner_text
  end

  file = File.open("#{File.dirname(__FILE__)}/../dealofday.com/deals.rss.html")
  doc = Nokogiri::XML.parse(file)

  test = TestSpider.new
  test.get_description(doc)

  #file = File.open("#{File.dirname(__FILE__)}/../dealofday.com/deal.html")
  #doc = Nokogiri::HTML.parse(file)
  #test.get_image(doc)


end

