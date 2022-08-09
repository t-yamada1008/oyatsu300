require 'open-uri'
require 'nokogiri'

# スクレイピングライブラリ
# # スクレイピングのコア機能
module Scraping::ScrapingCore
  def check_scraping_core
    logger.info 'ScrapingCoreの読み込みOK'
  end

  # 対象のURLをパースする
  def parse_document(url)
    # システム負荷対策の1.5~3秒ランダムスリープ
    sleep rand(1.5..3.0)
    logger.info url
    begin
      doc = Nokogiri::HTML.parse(URI.parse(url).open.read)
    rescue OpenURI::HTTPError => e
      logger.error e.message
    end
    doc
  end
end
