require 'dotenv/load'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'slack-ruby-client'
require 'figlet'

# models
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

# application modules
require './auth'
require './bot'

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [API, Auth]
