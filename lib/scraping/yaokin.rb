require 'open-uri'
require 'nokogiri'

# スクレイピングライブラリ
module Scraping
  # やおきん用
  module Yaokin
    include Scraping::ScrapingCore
    include Scraping::DownloadImage
    def check_scraping_yaokin
      p '読み込めてるよ！'
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

        # item_docの取得に失敗した場合は次のループへ
        next if item_doc.nil?

        # 商品名を取得
        item_name = item_doc.css('.verlign_m')[1].children.attribute('alt').value

        # 商品ジャンルを取得
        item_genre = i.split('/').pop(2).first

        # 商品価格を取得
        item_price = item_doc.css('p')[6].children[1].text

        # フリープライスの品物の場合、次のループへ
        next if item_price.include?('フリープライス')

        # '円'を切り取りIntegerに変換
        item_price = item_price.chop.to_i

        # 300円以上の品物の場合、次のループへ
        next if item_price > 300

        # 商品イメージのURLを取得
        item_image_url = base_url + item_doc.css('.verlign_m')[1].children.attribute('src').value

        # 商品データを確定
        item_data[:name] = item_name
        item_data[:genre] = item_genre
        item_data[:price] = item_price
        item_data[:image_url] = item_image_url
        item.push item_data
        p item_data
      end
      item
    end
  end
end
