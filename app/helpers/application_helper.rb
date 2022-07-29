module ApplicationHelper
  def page_title(page_title = '', admin: false)
    base_title = if admin
                   'おやつ300管理画面'
                 else
                   '遠足のおやつは300円まで'
                 end
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def active_if(path)
    # コントローラのパスを取得し、一致するする場合はactiveを返す
    path == controller_path ? 'active' : ''
  end
end
