source 'https://gems.ruby-china.org'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'jbuilder'

#cache
gem 'redis', '~> 3.2'
gem 'hiredis'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'second_level_cache', '~> 2.3.0'
gem 'request_store'

# 文件处理组件
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'carrierwave-ucloud', '~> 0.0.2'
gem 'dotenv-rails'

gem 'jwt'
gem 'resque'
gem 'jpush', '~> 4.0', '>= 4.0.6'

gem 'faraday'

# OneApm
gem 'oneapm_rpm','1.3.7'

# rack-attack
gem 'rack-attack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rubocop', require: false
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-resque', require: false
end

group :development do
  gem 'rails-erd'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'simplecov', require: false, group: :test

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :tools do
  gem 'rails-erd', require: false
end