# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

# Admin Root crumb
crumb :admin_root do
  link t('.admin_root'), admin_root_path
end

# Users List
crumb :admin_users do
  link t('admin.users.index.title'), admin_users_path
end

# User show
crumb :admin_user do |user|
  link user.name, admin_user_path(user)
  parent :admin_users
end

# User edit
crumb :edit_admin_user do |user|
  link admin_user.name, edit_admin_user_path(admin_user)
  parent :admin_users
end
