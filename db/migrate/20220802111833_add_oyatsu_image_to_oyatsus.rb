class AddOyatsuImageToOyatsus < ActiveRecord::Migration[6.1]
  def change
    add_column :oyatsus, :oyatsu_image, :string
  end
end
