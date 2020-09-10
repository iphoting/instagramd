require 'capybara/cucumber'
require "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/instagramd"

Capybara.app = Sinatra::Application.new
