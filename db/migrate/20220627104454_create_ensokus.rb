class CreateEnsokus < ActiveRecord::Migration[6.1]
  def change
    create_table :ensokus do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :purse, null: false, default: 300
      t.string :comment
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
