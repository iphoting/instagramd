#!/usr/bin/env rakeup
#\ -E deployment

require "#{File.dirname(__FILE__)}/instagramd"

run Sinatra::Application
