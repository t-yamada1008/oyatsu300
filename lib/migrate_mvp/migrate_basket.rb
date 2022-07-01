module MigrateMvp::MigrateBasket
  def migrate_basket
    f = File.open("#{Rails.root}/lib/migrate_mvp/edit_baskets.txt", 'r')
    f.each_with_index do |l, i|
      # baskets (id, quantity, oyatsu_id, user_id, created_at, updated_at)
      puts "---#{i}回目---"
      parse = l.split(/\t/)
      p parse
      # ユーザーidを元に遠足があればensoku_idをセット、なければuser_idから新規遠足を作成
      ensoku = if Ensoku.find_by(user_id: parse[3].to_i).present?
            Ensoku.find_by(user_id: parse[3].to_i)
          else
            User.find_by(id: parse[3].to_i).ensokus.create
          end
      # 既存のバスケット遠足と紐付け
      b = Basket.find(parse[0].to_i)
      b.update(ensoku_id: ensoku.id)
    end
    f.close
    p Basket.all
  end
end
