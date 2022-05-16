class CreateOyatsus < ActiveRecord::Migration[6.1]
  def change
    create_table :oyatsus do |t|
      t.string :name, null: false
      t.string :genre, null: false
      t.integer :price, null: false
      t.string :image_url

      t.timestamps
    end
  end
end
