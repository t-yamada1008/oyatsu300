require 'open-uri'
require 'nokogiri'
require 'fileutils'

# スクレイピング用画像ダウンロードモジュール
# Oyatsuテーブルのurlを元に画像をダウンロードし、oyatsu_imageに保存する
module Scraping::DownloadImage
  # 読み込み確認用メソッド
  def check_download_image
    p 'DownloadImageの読み込みOK'
  end

  # スクレイピングにて取得した画像URLを全てダウンロードする
  def download_all_images
    oyatsu = Oyatsu.all
    oyatsu.each do |o|
      # 管理画面からアップロードしたデータは除外
      if o[:image_url].present?
        file_path = create_file_path(o[:image_url], o[:id])
        download_image(o[:image_url], file_path)
      end
    end
  end

  private

  # ダウンロードメソッド
  def download_image(image_url, file_path)
    # image_urlもしくはファイルが存在する場合はダウンロードしない
    return 'ファイルが存在します' if File.exist?(file_path)

    # いらないかもだけど念の為対象URLへの負荷対策としてsleepを仕込んでおく
    sleep 1
    begin
      p image_url
      p file_path
      File.open(file_path, 'w+b') do |f|
        URI.parse(image_url).open do |u|
          f.write(u.read)
        end
      end
    rescue NoMethodError => e
      p  e.message
    end
  end

  def create_file_path(image_url, oyatsu_id)
    # ファイルの保存先はassetsとする
    # carrierwaveのアップローダーとの画像の扱いはview側で判断
    file_name = image_url.split('/').last.to_s
    dir_path = "#{Rails.root}/app/assets/images/downloads/oyatsu/oyatsu_image/#{oyatsu_id}"
    FileUtils.mkdir_p dir_path unless Dir.exist?(dir_path)
    "#{dir_path}/#{file_name}"
  end
end
