class CreateOyatsus < ActiveRecord::Migration[6.1]
  def change
    create_table :oyatsus do |t|
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
