require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"
require 'net/http'
require "../database/models/deal"
require "../database/models/store"
require "../database/models/category"
require "../database/models/deal_categoryship"

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

  def save_deal(item)
    description = item.xpath('description').inner_html
    # 剔除 description 中无用的字符串

    description_no_html = description.gsub(/<\/?.*?>/, '').gsub('Get this Deal', '').gsub('&nbsp;', '')

    get_text = description.xpath('//a').inner_text



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

    deal = Deal.new(:title => title, :description_pure => description_no_html.strip, :description => description,
                    :pubDate => date, :location => link.strip, :image => img, :source => 'dealtaker.com')

    categories = item.xpath('category')
    categories.each do |c|
      category_name = c.inner_html.strip
      category = Category.find_by_name(category_name)
      Category.new(:name => category_name).save if category.nil?
      c_new = Category.find_by_name(category_name)
      deal.categories << c_new
    end

    store.deals << deal
    store.save
  end

  def is_old_rss
    file = File.open("#{File.dirname(__FILE__)}/deals.rss.html")
    doc = Nokogiri::XML(file)
    publish_date = doc.xpath('//lastBuildDate').inner_text
    s = Time.parse(publish_date)

    puts s
  end

  def get_description(doc)
    items = get_node(doc, '//item')
    items.each do |item|
      des_html = item.xpath('description').inner_html
      description_doc = Nokogiri::HTML.parse(des_html)
      get_text = description_doc.xpath('//a').inner_text

      des_text = item.xpath('description').inner_text
      #p des_text
      #p des_html.sub(/<\/?[a-zA-Z]+[^><]*>/,'asd')
      #p des_html.gsub(/<\/?.*?>/, "").gsub('Get this Deal', '').gsub(/\s/, '')
      #p des_text
      p get_text
    end


  end

  # 得到源中的所有对象
  def get_rss_deal(doc)

    #uri = 'http://www.dealtaker.com/feed/offer/order-newest/limit-20/'
    #doc = Nokogiri::HTML(open(ui))

    #file = File.open("#{File.dirname(__FILE__)}/deals.rss.html")
    #doc = Nokogiri::XML(file)

    items = get_node(doc, '//item')
    deals = Deal.order("pubDate DESC").find_all_by_source('dealtaker.com')
    count = deals.count

    items.each do |item|
      if count != 0
        last_time = deals.first.pubDate
        pub_date = Time.parse(item.xpath('pubDate').inner_text)
        save_deal(item) if pub_date > last_time
      else
        save_deal(item)
      end
    end


  end

  def get_rss_category(doc)

    items = get_node(doc, '//item')
    items.each do |item|
      categories = item.xpath('category')
      categories.each do |category|
        puts category.inner_html.strip
      end
    end
  end

  def get_by_tag(doc, tag)
    item = get_node(doc, '//item')
    item.each { |it|
      path = it.xpath(tag).inner_html
      p path
    }
  end


  def is_last_deal_date(doc, date_label, current_time)

    dates = get_node(doc, "#{date_label}")
    current_time < Time.parse(dates.last.inner_text)
  end

  def get_last_deal
    deals = Deal.order("pubDate DESC").find_all_by_source('dealtaker.com')
    last_time = deals.first.pubDate
    p last_time
  end

  def test_category_deal
    d = Deal.find(82)
    c1 = Category.find(3)
    c2 = Category.find(4)
    #c1 = Category.new(:name => 'blue')
    #c2 = Category.new(:name => 'red')
    #dc1 = DealCategoryship.new(:deal => d, :category => c1)
    #dc2 = DealCategoryship.new(:deal => d, :category => c2)
    #d.deal_categoryships << dc1
    #d.deal_categoryships << dc2
    #d.save

    #d.categories << c1
    #d.categories << c2

    p c1.deals.size
    p d.categories.size
  end

end

