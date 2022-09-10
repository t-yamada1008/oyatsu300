class Basket < ApplicationRecord
  belongs_to :oyatsu
  belongs_to :ensoku

  with_options presence: true do
    validates :ensoku_id
    validates :oyatsu_id
    validates :quantity, numericality: { greater_than: 0 }
  end
end
