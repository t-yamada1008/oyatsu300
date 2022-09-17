require 'csv'

CSV.foreach("#{Rails.root}/db/csv/test/oyatsus.csv", headers: true) do |row|
  Oyatsu.create!(name: row['name'], price: row['price'], image_url: row['image_url'])
end
