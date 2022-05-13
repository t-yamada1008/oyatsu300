require 'open-uri'
require 'nokogiri'

# スクレイピング用モジュール
module Scraping
  # 画像ダウンロード用モジュール
  module DownloadImage
    # 読み込み確認用メソッド
    def check_download_image
      p 'DownloadImageの読み込みOK'
    end

    # ダウンロードメソッド
    def download(image_url, base_url, location_path)
      # いらないかもだけど念の為対象URLへの負荷対策としてsleepを仕込んでおく
      sleep 1
      url = base_url + image_url
      path = Rails.root.to_s + "/#{location_path}" + image_url
      p url
      p path
      File.open(path, 'w+b') do |f|
        URI.parse(url).open do |u|
          f.write(u.read)
        end
      end
    end

    # スクレイピングにて取得した画像URLを全てダウンロードする
    def download_all(base_url, location_path)
      oyatsu = Oyatsu.all
      oyatsu.each do |o|
        download(o[:image], base_url, location_path)
      end
    end
  end
end
