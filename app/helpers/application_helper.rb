module ApplicationHelper
  # ページタイトル設定
  def page_title(page_title = '', admin: false)
    base_title = if admin
                   'おやつ300管理画面'
                 else
                   '遠足のおやつは300円まで'
                 end
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # コントローラのパスを取得し、一致するする場合はactiveを返す
  def active_if(path)
    path == controller_path ? 'active' : ''
  end

  # 画像ファイル呼び出し
  def image_path(oyatsu)
    # スクレイピングデータがあるときはそっちを優先
    # スクレイピングデータがない場合はアップロード機能から呼び出し
    if oyatsu.image_url.present?
      "downloads/oyatsu/oyatsu_image/#{oyatsu.id}/#{oyatsu.image_url.split('/').last}"
    else
      oyatsu.oyatsu_image.url
    end
  end
end
