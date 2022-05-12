require 'open-uri'
require 'nokogiri'

# スクレイピング用モジュール
module Scraping
  # 画像ダウンロード用モジュール
  module DownloadImage
    def check_download_image
      p 'DownloadImageの読み込みOK'
    end

    def download(image_url, base_url, location_path)
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
  end
end
