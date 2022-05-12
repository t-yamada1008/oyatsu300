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

    # 対象のURLをパースする
    def parse_document(url)
      # システム負荷対策の1.5~3秒ランダムスリープ
      sleep rand(1.5..3.0)
      p url
      begin
        Nokogiri::HTML.parse(URI.parse(url).open.read)
      rescue OpenURI::HTTPError => e
        p e
      end
    end

    # ジャンルのURLを取得する
    def push_genre_url(documents_a, base_url, target_url)
      documents_a.each do |a|
        if a.attribute('href').present?
          href = a.attribute('href').value
          target_url.push base_url + href if (href.include? '/products_search') && (href.exclude? 'http://') && (href.exclude? 'goods')
        end
      end
    end

    # 商品のURLを取得する
    def push_item_url(documents_a, base_url, target_url)
      documents_a.each do |a|
        if a.attribute('href').present?
          href = a.attribute('href').value
          target_url.push base_url + href if href.include? '/item'
        end
      end
    end

    # やおきんのおかしデータを取得する
    def yaokin_oyatsu
      # 遷移元URL
      base_url = 'http://www.yaokin.com'
      # 全ての商品URL
      products_url = 'http://www.yaokin.com/products.html'
      # ジャンルurl
      genre_url = []
      # 商品url
      item_url = []
      # 商品
      item = []

      # 全ての商品htmlを取得してパース
      products_doc = parse_document(products_url)

      # 全ての商品htmlのa要素から商品ジャンルのリンクだけを取得する
      products_a = products_doc.css('a')
      push_genre_url(products_a, base_url, genre_url)

      # 商品ジャンルのリンクから単体商品のリンクを取得する
      genre_url.each do |g|
        # ジャンルhtmlを取得してパース
        genre_doc = parse_document(g)

        # ジャンルhtmlのa要素から単体商品のリンクだけを取得する
        genre_a = genre_doc.css('a')
        push_item_url(genre_a, base_url, item_url)
      end

      item_url.each do |i|
        # 商品データ
        item_data = {}
        # アイテムhtmlを取得してパース
        item_doc = parse_document(i)

        # アイテムhtml
        item_data[:name] = item_doc.css('.verlign_m')[1].children.attribute('alt').value
        item_data[:price] = item_doc.css('p')[6].children[1].text.chop
        item_data[:image] = item_doc.css('.verlign_m')[1].children.attribute('src').value

        item.push item_data
      end
      item
    end
    # oyatsu('http://www.yaokin.com/products_search/umaibo/item_M27001')
  end
end
