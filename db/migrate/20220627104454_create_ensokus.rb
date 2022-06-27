class CreateEnsokus < ActiveRecord::Migration[6.1]
  def change
    create_table :ensokus do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :purse, null: false
      t.string :comment

      t.timestamps
    end
  end
end
