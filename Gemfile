source 'https://rubygems.org'

ruby '3.3.1'

gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'redis', '~> 5.2'
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

gem 'guard'
gem 'guard-livereload', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails', '~> 3.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.5'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 7.1'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
end

group :development do
  # something here if needs
end

group :test do
  gem 'shoulda-matchers'
end
