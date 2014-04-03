require 'bundler/setup'
require 'sinatra/base'

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base

  # Direct media requests to the media directory.
  get(/^\/media\/.+/) do
    path = File.join($root, request.path)
    File.exist?(path) ? send_file(path) : 404
  end

  # All other requests are served from compiled site files.
  get(/.+/) do
    path = File.join($root, '_site',  request.path)
    path = File.join(path, 'index.html') unless path =~ /\.[a-z]+$/i
    File.exist?(path) ? send_file(path) : 404
  end

  not_found do
    send_file(File.join($root, '_site', '404.html'), {:status => 404})
  end

end

run SinatraStaticServer
