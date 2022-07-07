class RemoveQuantityFromBaskets < ActiveRecord::Migration[6.1]
  def change
    remove_column :baskets, :quantity, :integer
  end
end
