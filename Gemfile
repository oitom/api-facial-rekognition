source "https://rubygems.org"

gem "jets", "3.1.5"
gem 'uuid', '~> 2.3', '>= 2.3.8'
gem 'aws-sdk', '~> 3.0', '>= 3.1.0'
gem 'aws-sdk-rekognition'
gem 'aws-sdk-s3'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '11.1.1', platforms: [:mri, :mingw, :x64_mingw]
  gem 'shotgun'
  gem 'rack'
  gem 'puma'
end

group :test do
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
  gem 'launchy'
  gem 'capybara'
  gem 'simplecov-cobertura', :require => false
  gem 'simplecov-json', '0.2.0', :require => false
  gem 'simplecov', '<= 0.17.0', :require => false
end
