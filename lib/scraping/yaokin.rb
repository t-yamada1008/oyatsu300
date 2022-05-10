require 'open-uri'
require 'nokogiri'

def get_oyatsu(url)
  # urlにアクセスしてhtmlを取得する
  html = URI.parse(url).open.read

  # 取得したhtmlをNokogiriでパースする
  doc = Nokogiri::HTML.parse(html)

  # htmlのitem_nameを取得して出力する
  name = doc.css('.verlign_m')[1].children.attribute('alt').value
  price = doc.css('p')[6].children[1].text.chop
  img = doc.css('.verlign_m')[1].children.attribute('src').value

  puts name
  puts price
  puts img
end

get_oyatsu('http://www.yaokin.com/products_search/umaibo/item_M27001')
