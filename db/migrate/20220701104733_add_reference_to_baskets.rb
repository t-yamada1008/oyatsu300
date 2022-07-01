class AddReferenceToBaskets < ActiveRecord::Migration[6.1]
  def change
    add_reference :baskets, :ensoku, foreign_key: true
  end
end
