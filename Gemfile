source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.5', '>= 6.1.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# --- Add Gems ---
# Japanese localization
gem 'rails-i18n'

# Frontend
# bootstrap
gem 'bootstrap', '~> 5.0.2'
gem 'slim-rails'
gem 'html2slim'

# font-awesome
gem 'font-awesome-sass'

# Page nation
gem 'kaminari'

# Image
# gem 'carrierwave', '~> 2.2', '>= 2.2.2'
gem 'mini_magick', '~> 4.11'

# login
gem 'sorcery', '~> 0.16.3'

# rails6.1.5対処
gem 'net-smtp'
# ついでに以下の2つも追加しておく方が良さそう
gem 'net-imap'
gem 'net-pop'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Test
  gem 'rspec-rails'
  gem 'faker'

  # Debug and Code Formatting for development and test
  gem 'rails-flog', require: 'flog' # コンソールでのSQL整形
  gem 'pry-byebug'

  # scraping
  gem 'nokogiri', '~> 1.13', '>= 1.13.6'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Lint
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'bullet' # N+1問題チェック

  # Debug and Code Formatting
  gem 'better_errors' # railsのエラー画面整形
  gem 'binding_of_caller' # ブラウザ上でirb利用
  gem 'annotate' # schema情報をmodelやrootに記述
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


