class AddImageToOyatsus < ActiveRecord::Migration[6.1]
  def change
    add_column :oyatsus, :image, :string
  end
end
