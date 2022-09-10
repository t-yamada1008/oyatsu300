class ChangeColumnNullToBaskets < ActiveRecord::Migration[6.1]
  def change
    change_column_null :baskets, :ensoku_id, false
    change_column_null :baskets, :quantity, false
  end
end
