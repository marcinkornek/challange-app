source 'https://rubygems.org'
ruby '2.1.2'

# core
gem 'rails', '4.1.1'
gem 'pg'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'devise'
gem 'faker', '1.1.2'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'bootstrap-glyphicons'
gem 'rmagick', '2.13.2'
gem 'carrierwave'
gem 'omniauth-github', '~> 1.1.2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# gem 'dotenv-rails' # it's required to use .env !
gem 'redcarpet' #Markdown format processor
gem 'figaro' #menage application.yml file with secret keys, works with pusher too
gem 'sidekiq' #backend server - works only in development, needs Redis server and Sidekiq server running
gem 'pusher' #realtime push notifications
gem 'gritter' # JQuery growl-like notification plugin
gem 'fog', '~> 1.23.0' # Ruby cloud services library
gem 'acts-as-taggable-on', '~> 3.4' # tagging

# frontend
gem 'slim-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'font-awesome-rails'

# background processing
gem 'devise-async'

# doc
gem 'sdoc', '~> 0.4.0',          group: :doc

# development
group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller' #better_errors gem
  gem 'letter_opener_web', '~> 1.2.0'
  gem 'letter_opener'
end

# testing
group :test do
  gem 'database_cleaner',   '~> 1.2.0'
  gem 'capybara',           github: 'jnicklas/capybara' # master until rspec3 fixes are released #~> 2.2.0'
  gem 'poltergeist',        '~> 1.5.0'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'cucumber-rails',     '~> 1.4.1', require: false
  gem 'factory_girl'
  gem 'pusher-fake'
end

group :development, :test do
  gem 'quiet_assets' #dont show assets in 'rails s' log (it's much more cleaner)
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'rspec-rails'
  gem 'guard-rspec', '2.5.0'
  gem 'debugger2'
end

group :production do
  gem 'rails_12factor'
end

