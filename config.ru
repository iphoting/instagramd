#!/usr/bin/env rakeup
#\ -E deployment

map '/assets' do
	require 'sprockets'
	environment = Sprockets::Environment.new
	environment.append_path 'assets/images'
	run environment
end

map '/' do
	require "#{File.dirname(__FILE__)}/instagramd"
	run Sinatra::Application
end
