source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1', '>= 6.1.6.1'
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

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

### --- Add Gems ---
# --- All Enviroments ---
# login
gem 'sorcery', '~> 0.16.3'

# Japanese localization
gem 'rails-i18n'
gem 'enum_help'

# 環境設定用gem
gem 'config'

# Frontend
# bootstrap
gem 'slim-rails'
gem 'html2slim'

# font-awesome
gem 'font-awesome-sass'

# Page nation
gem 'kaminari'

# search
gem 'ransack'

# Image
gem 'carrierwave'
gem 'mini_magick'

# rails6.1.5対処
gem 'net-smtp'
# ついでに以下の2つも追加しておく方が良さそうとのこと
gem 'net-imap'
gem 'net-pop'

# 管理者画面用パンくずリスト
gem 'gretel'

# redis
# session管理のみの利用なのでacition-pack
gem 'redis-actionpack'

# 静的ページ作成
gem 'high_voltage', '~> 3.1', '>= 3.1.2'

# サイトマップ作成
gem 'sitemap_generator'

# --- Development and Test ---
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Test
  gem 'rspec-rails'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'rubocop-rspec', require: false

  # Debug and Code Formatting for development and test
  gem 'rails-flog', require: 'flog' # コンソールでのSQL整形
  gem 'pry-byebug'

  # scraping
  gem 'nokogiri', '~> 1.13', '>= 1.13.6'
end

# --- Development ---
group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # email
  gem 'letter_opener_web'

  # Lint
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'bullet' # N+1問題チェック

  # Debug and Code Formatting
  gem 'better_errors' # railsのエラー画面整形
  gem 'binding_of_caller' # ブラウザ上でirb利用
  gem 'annotate' # schema情報をmodelやrootに記述

  # 自動デプロイ
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem "capistrano3-unicorn"
end

# --- Test ---
group :test do

  # capybara for RSpec
  gem 'capybara'
  gem 'webdrivers'
  gem 'mock_redis'

  # Coverage
  gem 'simplecov', require: false
end

# --- Production ---
group :production do
  # systemd用
  gem "sd_notify"

  # unicorn導入
  gem 'unicorn'
end
