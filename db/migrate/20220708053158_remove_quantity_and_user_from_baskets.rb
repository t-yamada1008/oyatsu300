class RemoveQuantityAndUserFromBaskets < ActiveRecord::Migration[6.1]
  def change
    remove_column :baskets, :quantity, :integer
    remove_reference :baskets, :user, null: false, foreign_key: true
  end
end
