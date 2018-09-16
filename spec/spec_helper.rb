ENV['RACK_ENV'] = 'test'
ENV['SLACK_CLIENT_ID'] = 'test id'
ENV['SLACK_API_SECRET'] = 'test secret'
ENV['SLACK_REDIRECT_URI'] = 'test redirect'
ENV['SLACK_VERIFICATION_TOKEN'] = 'test token'

require 'sinatra/activerecord'
require 'sinatra/base'
require 'slack-ruby-client'

require 'rack/test'
require 'rspec'
require 'webmock/rspec'

require_relative '../auth.rb'
require_relative '../api.rb'

# models
require_relative '../models/team.rb'

module RSpecMixin
  include Rack::Test::Methods

  # suppress logging noise
  ActiveRecord::Base.logger = nil unless ENV['LOG'] == true
  def app() described_class end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
