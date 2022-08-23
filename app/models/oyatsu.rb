# おやつモデル
class Oyatsu < ApplicationRecord
  mount_uploader :oyatsu_image, OyatsuImageUploader
  include Scraping::Yaokin

  has_many :baskets
  has_many :oyatsu_baksets, through: :baskets, source: :ensoku
  has_many :reviews

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, numericality: { only_integer: true }

  def current_user_review(user)
    reviews.find_by(user_id: user.id)
  end
end
