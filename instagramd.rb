require 'rubygems'
require 'bundler'

require 'sinatra'
require 'haml'
require 'rack-timeout'
require 'uri'
require 'net/http'

configure :production do
	require 'rack/ssl-enforcer'
	use Rack::SslEnforcer, :hsts => true
end

use Rack::Timeout
Rack::Timeout.timeout = 10
use Rack::ConditionalGet
use Rack::ETag
use Rack::ContentLength
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
	path = URI::split(get_final_location(url))[5]
	code_match = /\/p\/(?<code>\S+[^\/])\/?/.match(path)
	return nil if code_match.nil?
	code = code_match[:code]
	return "https://instagram.com/p/#{code}/media/?size=l"
end

#recursively get the final location (after following all redirects) for an url
def get_final_location(url)
	Net::HTTP.get_response(URI.parse(url)) do |res|
		location = res["location"]
		return url if location.nil?
		return get_final_location(location)
	end
end
