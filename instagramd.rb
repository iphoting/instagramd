require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'rack/ssl-enforcer'
require 'rack-timeout'
require 'uri'

configure :production do
	use Rack::SslEnforcer, :hsts => true
end

use Rack::Timeout
Rack::Timeout.timeout = 10
use Rack::ContentLength
use Rack::ConditionalGet
use Rack::Deflater

get '/' do
	if params[:url]
		begin
			@url = URI::parse(params[:url])
			@img_src = get_img_src(params[:url])
			redirect to('/') if @img_src.nil?
			haml :image
		rescue URI::InvalidURIError
			redirect to('/')
		end
	else
		haml :form
	end
end

post '/url' do
	begin
		@url = URI::parse(params[:url])
		@img_src = get_img_src(params[:url])
		redirect to('/') if @img_src.nil?
		haml :image
	rescue URI::InvalidURIError
		redirect to('/')
	end
end

get '/raw' do
	begin
		@url = URI::parse(params[:url])
		@img_src = get_img_src(params[:url])
		redirect to('/') if @img_src.nil?
		haml :raw, :layout => false
	rescue URI::InvalidURIError
		redirect to('/')
	end
end

def get_img_src(url)
	path = URI::split(url)[5]
	code_match = /\/p\/(?<code>\w+)\/?/.match(path)
	return nil if code_match.nil?
	code = code_match[:code]
	return "https://instagram.com/p/#{code}/media/?size=l"
end
