source "https://rubygems.org"

ruby File.read('.ruby-version', mode: 'rb').chomp
#ruby-gemset=instagramd

gem 'rake'

gem 'rack'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'haml', "~>5.2"
gem 'rdiscount'
gem 'rack-ssl-enforcer'
gem 'rack-timeout'
gem 'rack-flash3'
gem 'addressable', '>= 2.8.0'
gem 'sprockets', '~> 4.0'

group :production do
	gem 'newrelic_rpm'
	gem 'iodine', '~> 0.7'
end

group :test do
	gem 'cucumber'
	gem 'capybara', '>= 3.35.3'
	gem 'selenium-webdriver'
	gem 'rspec-expectations'
end
