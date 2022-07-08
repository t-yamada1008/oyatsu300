class Basket < ApplicationRecord
  include MigrateMvp::MigrateBasket

  belongs_to :oyatsu
  belongs_to :ensoku
end
