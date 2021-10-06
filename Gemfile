source 'https://rubygems.org'

gem 'sidekiq', '~> 6.2.2', require: 'sidekiq/api'
gem 'eventmachine', '~> 1.2.0'
# https://github.com/seuros/hosted_graphite/pull/16
gem 'hosted_graphite', github: 'honeycomb-tv/hosted_graphite', branch: 'add-enabled-flag'
gem 'dotenv'

group :development do
  gem 'pry'
  gem 'rubocop'
end

group :test do
  gem 'rspec'
end
