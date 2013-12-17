require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'rack/ssl-enforcer'
require 'uri'

configure :production do
	use Rack::SslEnforcer, :hsts => true
end

use Rack::ContentLength
use Rack::Deflater
use Rack::ConditionalGet

get '/' do
	@url = params[:url] unless params.nil?
	haml :form
end

post '/url' do
	begin
		@url = URI::parse(params[:url])
		path = URI::split(params[:url])[5]
		code_match = /\/p\/(?<code>\w+)\/?/.match(path)
		redirect to('/') if code_match.nil?
		@code = code_match[:code]
		haml :image
	rescue URI::InvalidURIError
		redirect to('/')
	end
end
