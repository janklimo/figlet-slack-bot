require 'dotenv/load'

# modules required by both Sinatra modules
require 'sinatra/activerecord'
require 'sinatra/base'
require 'slack-ruby-client'
require 'json'

# models
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

# application modules
require './auth'
require './api'

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [API, Auth]
