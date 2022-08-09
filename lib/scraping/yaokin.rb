require 'open-uri'
require 'nokogiri'

# スクレイピングライブラリ
# 取得したデータをOyatsuテーブルに保存する
# やおきん用
module Scraping::Yaokin
  # 定数
  # 遷移元URL
  BASE_URL = 'http://www.yaokin.com'.freeze
  # 全ての商品URL
  PRODUCTS_URL = 'http://www.yaokin.com/products.html'.freeze

  include Scraping::ScrapingCore
  include Scraping::DownloadImage

  # 確認用スクリプト
  def check_scraping_yaokin
    p '読み込めてるよ！'
  end

  # やおきんのおかしデータを取得する
  def yaokin_oyatsu
    # 全ての商品htmlを取得してパース
    products_doc = parse_document(PRODUCTS_URL)
    products_a = products_doc.css('a')
    # ジャンルのURLを取得する
    genre_url_arr = genre_url(products_a)
    # 商品のURLを取得する
    item_url_arr = item_url(genre_url_arr)
    # 商品のデータを取得する
    item_info(item_url_arr)
  end

  private

  # ジャンルのURLを取得する
  def genre_url(products_a)
    genre_url_arr = []
    products_a.each do |a|
      next unless a.attribute('href').present?

      href = a.attribute('href').value
      genre_url_arr.push BASE_URL + href if (href.include? '/products_search') && (href.exclude? 'http://') && (href.exclude? 'goods')
    end
    genre_url_arr
  end

  # 商品のURLを取得する
  def item_url(genre_url_arr)
    item_url_arr = []
    # 商品ジャンルのリンクから単体商品のリンクを取得する
    genre_url_arr.each do |g|
      # ジャンルhtmlを取得してパース
      genre_doc = parse_document(g)

      # ジャンルhtmlのa要素から単体商品のリンクだけを取得する
      genre_doc_a = genre_doc.css('a')
      genre_doc_a.each do |a|
        if a.attribute('href').present?
          href = a.attribute('href').value
          item_url_arr.push BASE_URL + href if href.include? '/item'
        end
      end
    end
    item_url_arr
  end

  # 商品のデータを取得する
  def item_info(item_url_arr)
    item = []
    item_url_arr.each do |i|
      # 商品データ
      item_data = {}
      # アイテムhtmlを取得してパース
      item_doc = parse_document(i)

      # item_docの取得に失敗した場合は次のループへ
      next if item_doc.nil?

      # 商品名を取得
      item_data[:name] = item_doc.css('.verlign_m')[1].children.attribute('alt').value

      # 商品価格を取得
      item_price = item_doc.css('p')[6].children[1].text

      # フリープライスの品物の場合、次のループへ
      next if item_price.include?('フリープライス')

      # '円'を切り取りIntegerに変換
      item_price = item_price.chop.to_i

      # 300円以上の品物の場合、次のループへ
      next if item_price > 300

      item_data[:price] = item_price

      # 商品イメージのURLを取得
      item_data[:image_url] = BASE_URL + item_doc.css('.verlign_m')[1].children.attribute('src').value

      # 商品イメージののファイル名を取得
      item_data[:oyatsu_image] = item_data[:image_url].split('/').last

      p item_data
      item.push item_data
    end
    item
  end
end
