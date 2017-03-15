source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.9.3'
gem 'active_skin'
gem 'activeadmin', github: 'activeadmin'
gem 'activeadmin_addons'
gem 'aws-sdk', '~> 2.5'
gem 'aws-sdk-rails'
gem 'clockwork'
gem 'coffee-rails', '~> 4.2'
gem 'delayed_job_active_record'
gem 'devise'
gem 'devise-i18n'
gem 'heroku-stage'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'paperclip', '~> 5.0'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.0.2'
gem 'rails-i18n'
gem 'recipient_interceptor'
gem 'responders'
gem 'sass-rails', '~> 5.0'
gem 'sentry-raven'
gem 'simple_token_authentication', '~> 1.0'
gem 'spring'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'versionist'

group :production do
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

group :test do
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'shoulda-matchers', require: false
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
