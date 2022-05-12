require 'open-uri'
require 'nokogiri'

# スクレイピングライブラリ
module Scraping
  # スクレイピングのコア機能
  module ScrapingCore
    def check_scraping_core
      p 'ScrapingCoreの読み込みOK'
    end

    # 対象のURLをパースする
    def parse_document(url)
      # システム負荷対策の1.5~3秒ランダムスリープ
      sleep rand(1.5..3.0)
      p url
      begin
        Nokogiri::HTML.parse(URI.parse(url).open.read)
      rescue OpenURI::HTTPError => e
        p e.message
      end
    end
  end
end
