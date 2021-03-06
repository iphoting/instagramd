require 'rubygems'
require 'bundler/setup'

require 'rack'

require 'rdiscount'
require 'haml'
require 'sinatra'
require 'sinatra/multi_route'

require 'rack-timeout'
require 'rack-flash'
require 'addressable/uri'
require 'uri'
require 'net/http'

configure :production do
	require 'newrelic_rpm' if ENV["NEW_RELIC_LICENSE_KEY"] and ENV["NEW_RELIC_APP_NAME"]
	require 'rack/ssl-enforcer'
	use Rack::SslEnforcer, :hsts => true
end

use Rack::Timeout, service_timeout: 10
use Rack::ConditionalGet
use Rack::ETag
use Rack::ContentLength
use Rack::Deflater

enable :sessions
use Rack::Flash

get '/' do
	if params[:url]
		redirect to("/url?url=#{params[:url]}")
	else
		@error = flash[:error] unless flash[:error].nil?
		@notice = flash[:notice] unless flash[:notice].nil?
		haml :form
	end
end

route :post, :get, ['/url', '/raw'] do
	begin
		unless params[:url] and valid_url?(params[:url])
			flash[:error] = "Invalid URL entered!"
			redirect to('/')
		else
			@url = URI::parse(params[:url])
			@img_src = get_img_src(params[:url])
			if @img_src.nil?
				flash[:error] = "Instagram Raw Image Not Found!"
				redirect to('/')
			end
			if request.path_info == '/raw'
				haml :raw, :layout => false
			else
				haml :image
			end
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
