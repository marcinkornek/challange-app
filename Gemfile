source 'https://rubygems.org'

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

# frontend
gem 'slim-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# doc
gem 'sdoc', '~> 0.4.0',          group: :doc

# development
group :development do
  gem 'spring'
end

# testing
group :test do
  gem "database_cleaner",   "~> 1.2.0"
  gem "capybara",           github: "jnicklas/capybara" # master until rspec3 fixes are released #~> 2.2.0"
  gem "poltergeist",        "~> 1.5.0"
  gem "factory_girl_rails", "~> 4.2.0"
  gem "cucumber-rails",     "~> 1.4.1", require: false
  gem "factory_girl"
end

group :development, :test do
  gem 'quiet_assets' #nie wyświetla requestów o assety w logu "rails s"
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem "rspec-rails"
  gem 'guard-rspec', '2.5.0'
  gem 'debugger2'
end

