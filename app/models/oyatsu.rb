# おやつモデル
class Oyatsu < ApplicationRecord
  include Scraping::Yaokin

  has_many :baskets

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, numericality: { only_integer: true }
end
