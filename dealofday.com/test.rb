require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "iconv"

class TestSpider

  date = Time.parse('Thu, 12 Apr 2012 14:24:36 +0000')
  now = Time.now
  d = now.to_i - date.to_i
  p d/(60*60*24)

  p 'blue'.start_with?('B', 'b')
  p 'Aa'.to_a
  'Aa'.select { |a| p a }
end

