class RemoveGenreFromOyatsus < ActiveRecord::Migration[6.1]
  def change
    remove_column :oyatsus, :genre, :string
  end
end
