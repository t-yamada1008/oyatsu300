class Basket < ApplicationRecord
  belongs_to :oyatsu
  belongs_to :user

  validates :quantity, numericality: { only_integer: true }
end
