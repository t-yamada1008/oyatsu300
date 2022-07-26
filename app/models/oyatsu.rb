# おやつモデル
class Oyatsu < ApplicationRecord
  include Scraping::Yaokin

  has_many :baskets
  has_many :oyatsu_baksets, through: :baskets, source: :ensoku

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, numericality: { only_integer: true }

  def oyatsu_count(ensoku)
    oyatsu_baksets.where(id: ensoku).count
  end
end
