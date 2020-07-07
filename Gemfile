source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'active_hash'
gem 'hamlit-rails'
gem 'rails-i18n'
gem 'simple_form'
gem 'stripe'

gem 'business_time'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'

gem 'acts_as_list'

gem 'carrierwave'
gem 'cloudinary'
gem 'enumerize'
gem 'gon'

group :development, :test do
  gem 'better_errors'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'erb2haml'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'stripe-ruby-mock', '~> 3.0.1', require: 'stripe_mock'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
