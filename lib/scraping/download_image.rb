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
    def download_image(image_url, genre)
      # ファイルの保存先はapp/assets/images/download_imagesに固定
      dir_download_images = "#{Rails.root}/app/assets/images/download_images"
      Dir.mkdir dir_download_images unless Dir.exist?(dir_download_images)
      # ジャンルごとにファイルの保存先を分ける
      dir_path = "#{dir_download_images}/#{genre}"
      Dir.mkdir dir_path unless Dir.exist?(dir_path)
      # ファイル名を指定
      file_name = "#{dir_path}/#{image_url.split('/').last}"

      p image_url
      p file_name

      # ファイルが存在する場合はダウンロード
      return if File.exist?(file_name)

      # いらないかもだけど念の為対象URLへの負荷対策としてsleepを仕込んでおく
      sleep 1
      File.open(file_name, 'w+b') do |f|
        URI.parse(image_url).open do |u|
          f.write(u.read)
        end
      end
    end

    # スクレイピングにて取得した画像URLを全てダウンロードする
    def download_all_images
      oyatsu = Oyatsu.all
      oyatsu.each do |o|
        download_image(o[:image_url], o[:genre])
      end
    end
  end
end
