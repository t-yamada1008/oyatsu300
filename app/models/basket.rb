class Basket < ApplicationRecord
  belongs_to :oyatsu
  belongs_to :basket

  validates :quantity, numericality: { only_integer: true }
end
