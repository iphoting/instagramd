source "https://rubygems.org"

ruby File.read('.ruby-version', mode: 'rb').chomp
#ruby-gemset=instagramd

gem 'rack'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'haml', "~>5.1"
gem 'rdiscount'
gem 'rack-ssl-enforcer'
gem 'rack-timeout'
gem 'rack-flash3'
gem 'addressable'
gem 'sprockets', '~> 4.0'

group :production do
	gem 'newrelic_rpm'
	gem 'iodine', '~> 0.7'
end
