class AddGenreToOyatsus < ActiveRecord::Migration[6.1]
  def change
    add_column :oyatsus, :genre, :string, null: false
  end
end
