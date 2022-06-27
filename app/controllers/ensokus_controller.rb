class EnsokusController < ApplicationController
  # 遠足一覧画面
  def index; end

  # 新規遠足作成
  def create
    @ensoku = current_user.ensokus.create
  end

  # 遠足一覧画面から
  # 更新を押下したらおかし選択画面に飛ぶ
  def update

  end

  # 遠足一覧画面から
  # 気に入らないから消す
  def destroy

  end

end
