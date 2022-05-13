# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include Scraping::Yaokin

# おやつデータをDBに保存する
item = Oyatsu.new.yaokin_oyatsu
p item
item.each do |i|
  Oyatsu.find_or_create_by!(
    name: i[:name]
  ) do |oyatsu|
    oyatsu.name = i[:name]
    oyatsu.genre = i[:genre]
    oyatsu.price = i[:price]
    oyatsu.image = i[:image]
  end
end

