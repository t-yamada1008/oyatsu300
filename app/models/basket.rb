class Basket < ApplicationRecord
  include MigrateMvp::MigrateBasket

  belongs_to :oyatsu
  belongs_to :user
  belongs_to :ensoku

  validates :quantity, numericality: { only_integer: true }
end
