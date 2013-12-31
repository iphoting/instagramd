require 'rubygems'
require 'bundler/setup'

require 'rdiscount'
require 'haml'
require 'sinatra'

require 'rack-timeout'
require 'rack-flash'
require 'addressable/uri'
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

enable :sessions
use Rack::Flash

get '/' do
	if params[:url]
		begin
			unless valid_url?(params[:url])
				flash[:error] = "Invalid URL entered!"
				redirect to('/')
			else
				@url = URI::parse(params[:url])
				@img_src = get_img_src(params[:url])
				if @img_src.nil?
					flash[:error] = "Instagram Raw Image Not Found!"
					redirect to('/')
				end
				haml :image
			end
		rescue URI::InvalidURIError
			flash[:error] = "Invalid URL entered!"
			redirect to('/')
		end
	else
		@error = flash[:error] unless flash[:error].nil?
		@notice = flash[:notice] unless flash[:notice].nil?
		haml :form
	end
end

post '/url' do
	begin
		unless valid_url?(params[:url])
			flash[:error] = "Invalid URL entered!"
			redirect to('/')
		else
			@url = URI::parse(params[:url])
			@img_src = get_img_src(params[:url])
			if @img_src.nil?
				flash[:error] = "Instagram Raw Image Not Found!"
				redirect to('/')
			end
			haml :image
		end
	rescue URI::InvalidURIError
		flash[:error] = "Invalid URL entered!"
		redirect to('/')
	end
end

get '/raw' do
	begin
		unless valid_url?(params[:url])
			flash[:error] = "Invalid URL entered!"
			redirect to('/')
		else
			@url = URI::parse(params[:url])
			@img_src = get_img_src(params[:url])
			if @img_src.nil?
				flash[:error] = "Instagram Raw Image Not Found!"
				redirect to('/')
			end
			haml :raw, :layout => false
		end
	rescue URI::InvalidURIError
		flash[:error] = "Invalid URL entered!"
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

def valid_url?(url)
  parsed = Addressable::URI.parse(url) or return false
  %w(http https).include?(parsed.scheme)
rescue Addressable::URI::InvalidURIError
  false
end
