source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "shrine"
gem "aws-sdk-s3"

gem "taglib-ruby"

gem "acts-as-taggable-on"

gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "pundit"

gem "kramdown"

gem "paper_trail"
gem "paper_trail-globalid"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "localhost"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem "view_component"
gem "vite_rails"

gem "turbo-rails"

gem "dry-initializer"

gem "sentry-ruby"
gem "sentry-rails"
gem "sd_notify"

gem "rack-google-analytics", require: "rack/google-analytics"

group :test do
  gem "rspec-rails"
  gem "capybara"

  gem "selenium-webdriver"
  gem "launchy"
end

group :deployment do
  gem "kamal"
end

group :development, :test do
  gem "factory_bot_rails", require: false
  gem "faker"

  gem "pry"

  gem "dotenv-rails"
  gem "brakeman"
  gem "standard", require: false
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rails", require: false
end
