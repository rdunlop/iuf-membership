# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.open(File.expand_path('.ruby-version', File.dirname(__FILE__))) { |f| f.read.chomp }

# Base Gems
gem 'dotenv-rails'
gem 'pg', '>= 0.18', '< 1.6'
gem 'puma', '< 6'
gem 'rails', '~> 6.1.7'

# Behavior
gem 'administrate'
gem 'administrate_exportable'
gem 'audited'
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'paypal-server-sdk'
gem 'pundit'
gem 'rolify'

# Styling
gem 'sass-rails', '~> 6'

# Gems we may be able to delete:
gem 'jbuilder', '~> 2.11'

# Integrations
gem 'aws-sdk-rails'
gem 'rollbar'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'capistrano', require: false
gem 'capistrano-rails', require: false
gem 'capistrano-rvm', require: false
gem 'capistrano3-puma', '5.2.0', require: false

group :development, :test do
  gem 'bundler-audit'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.9'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'shakapacker', '= 8.0'
