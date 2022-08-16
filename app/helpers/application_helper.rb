module ApplicationHelper
  # ページタイトル設定
  def page_title(page_title = '', admin: false)
    base_title = if admin
                   t('.base_title_admin')
                 else
                   t('.base_title')
                 end
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # OGP: 画像
  def og_image(page_image = '')
    base_image = asset_path('logo_transparent.png')
    page_image.empty? ? base_image : page_image
  end

  # OGP: 説明
  def og_description(page_description = '')
    base_description = t('.base_description')
    page_description.empty? ? base_description : page_description
  end

  # 画像ファイル呼び出し
  def image_path(oyatsu)
    # スクレイピングデータがあるときはそっちを優先
    # スクレイピングデータがない場合はアップロード機能から呼び出し
    if oyatsu.image_url.present?
      asset_path("downloads/oyatsu/oyatsu_image/#{oyatsu.id}/#{oyatsu.image_url.split('/').last}")
    else
      oyatsu.oyatsu_image.url
    end
  end

  # コントローラのパスを取得し、一致するする場合はactiveを返す
  def active_if(path)
    path == controller_path ? 'active' : ''
  end
end
