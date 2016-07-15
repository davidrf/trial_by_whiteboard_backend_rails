source 'https://rubygems.org'

ruby '2.3.0'

gem 'bcrypt', '~> 3.1.7'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rack-cors'
gem 'rails', '~> 5.0.0'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'rspec-rails', '3.5.1'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'coveralls', require: false
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end
