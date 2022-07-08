class Ensoku < ApplicationRecord
  has_many :baskets, dependent: :destroy
  belongs_to :user
  has_many :basket_oyatsus, through: :baskets, source: :oyatsu

  validates :purse, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 300
  }
  validates :comment, length: { maximum: 65_535 }
  validates :comment, length: { maximum: 65_535 }

  enum status: {
    selecting: 0,
    close: 1,
    open: 2
  }

  def basket_in(oyatsu)
    basket_oyatsus << oyatsu
  end

  def basket_oyatsu_exists?(oyatsu)
    baskets.where(oyatsu_id: oyatsu).exists?
  end

  def basket_find(oyatsu)
    baskets.find_by(oyatsu_id: oyatsu)
  end
end
