source 'https://rubygems.org'

ruby '2.2.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.5'

gem 'rack-cors', require: 'rack/cors'

gem 'mongoid', '~> 6.0.0'
gem 'mongoid-grid_fs'

gem 'carrierwave', '~> 0.11.2' #TODO: Update to version 1
gem 'carrierwave-base64'
gem 'carrierwave-mongoid', '~> 0.10.0', require: 'carrierwave/mongoid'
gem 'pdf-reader'
gem 'sanitize'

gem 'active_model_serializers'

gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate_mongoid'

gem 'bcrypt', '~> 3.1.7'
gem 'jwt'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Use Capistrano for deployment
  #gem 'capistrano-rails'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Brakeman is used to detect security risks in the application
  gem 'brakeman', require: false
  # RuboCop is a static code analyzer tool that will ensure code quality
  gem 'rubocop', require: false
  # Looks for query optimations to avoid n+1 issues. Read more: https://sitepoint.com/silver-bullet-n1-problem
  # TODO: Has an issue with no mongoid support v6.0.0, re-asses later
  #gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
