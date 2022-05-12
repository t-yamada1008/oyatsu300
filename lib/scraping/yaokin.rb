require 'open-uri'
require 'nokogiri'

# スクレイピングライブラリ
module Scraping
  # やおきん用
  module Yaokin
    def test
      p '読み込めてるよ！'
    end

    def oyatsu(url)
      # urlにアクセスしてhtmlを取得する
      html = URI.parse(url).open.read

      # 取得したhtmlをNokogiriでパースする
      doc = Nokogiri::HTML.parse(html)

      # htmlの要素を取得して出力する
      name = doc.css('.verlign_m')[1].children.attribute('alt').value
      price = doc.css('p')[6].children[1].text.chop
      img = doc.css('.verlign_m')[1].children.attribute('src').value

      puts name
      puts price
      puts img
    end

    def yaokin_oyatsu
      # 遷移元URL
      base_url = 'http://www.yaokin.com'
      # 全ての商品URL
      products_url = 'http://www.yaokin.com/products.html'

      # 全ての商品htmlを取得してパース
      html = URI.parse(products_url).open.read
      doc = Nokogiri::HTML.parse(html)

      # 全ての商品htmlのa要素からリンクだけを取得する
      next_url = []
      products_a = doc.css('a')
      products_a.each do |d|
        href = d.attribute('href').value
        next_url.push href if href.include? '/products_search'
      end
      next_url
    end
    # oyatsu('http://www.yaokin.com/products_search/umaibo/item_M27001')
  end
end
