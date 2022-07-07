module MigrateMvp::MigrateBasket
  def migrate_basket_user
    f = File.open("#{Rails.root}/lib/migrate_mvp/mvp_baskets_data.txt", 'r')
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

  def migrate_basekt_quantitiy
    f = File.open("#{Rails.root}/lib/migrate_mvp/mvp_baskets_data.txt", 'r')
    f.each_with_index do |l, i|
      # baskets (id, quantity, oyatsu_id, user_id, created_at, updated_at)
      puts "---#{i}回目---"
      parse = l.split(/\t/)
      p parse
      # quantity - 1の数だけbasketレコードが存在するようにする
      # - 1なのは既存に既に1つあるため
      # user取得
      quantity = parse[1].to_i - 1
      oyatsu_id = parse[2]
      user = User.find(parse[3])
      ensoku_id = user.baskets.last.ensoku_id
      # userが持つbasketを取得
      quantity.times do
        b = user.baskets.new
        b.oyatsu_id = oyatsu_id
        b.ensoku_id = ensoku_id
        b.save
      end
    end
    f.close
    p Basket.all
  end
end
