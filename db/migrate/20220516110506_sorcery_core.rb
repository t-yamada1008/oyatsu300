class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :purse, null: false
      t.string :comment
      # 今回はnullでもokにする
      #t.string :email,            null: false, index: { unique: true }
      t.string :email
      t.string :crypted_password
      t.string :salt

      t.timestamps                null: false
    end
  end
end
