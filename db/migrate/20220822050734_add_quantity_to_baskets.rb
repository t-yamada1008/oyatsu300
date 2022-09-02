class AddQuantityToBaskets < ActiveRecord::Migration[6.1]
  def change
    add_column :baskets, :quantity, :integer, default: 0
  end
end
