class CreateBaskets < ActiveRecord::Migration[6.1]
  def change
    create_table :baskets do |t|
      t.integer :oatsu_id
      t.integer :user_id
      t.integer :quantitiy

      t.timestamps
    end
  end
end
