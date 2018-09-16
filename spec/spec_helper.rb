require 'sinatra/activerecord'
require 'sinatra/base'
require 'rack/test'
require 'rspec'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'
ENV['SLACK_CLIENT_ID'] = 'test id'
ENV['SLACK_API_SECRET'] = 'test secret'
ENV['SLACK_REDIRECT_URI'] = 'test redirect'
ENV['SLACK_VERIFICATION_TOKEN'] = 'test token'

require 'slack-ruby-client'
require File.expand_path '../../auth.rb', __FILE__
require File.expand_path '../../bot.rb', __FILE__

# models
require File.expand_path '../../models/team.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  # suppress logging noise
  ActiveRecord::Base.logger = nil unless ENV['LOG'] == true
  def app() described_class end
end

RSpec.configure { |c| c.include RSpecMixin }
