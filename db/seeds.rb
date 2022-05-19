# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include Scraping::Yaokin

# バナナをDBに保存する
Oyatsu.find_or_create_by!(
  name: 'バナナ'
) do |oyatsu|
  oyatsu.name = 'バナナ'
  oyatsu.genre = 'banana'
  oyatsu.price = 100
  oyatsu.image_url = "#{Rails.root}/app/assets/images/preset_images/banana.png"
end

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
    oyatsu.image_url = i[:image_url]
  end
end
item.download_all_images
