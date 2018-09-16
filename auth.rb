# frozen_string_literal: true

SLACK_CONFIG = {
  slack_client_id: ENV['SLACK_CLIENT_ID'],
  slack_api_secret: ENV['SLACK_API_SECRET'],
  slack_redirect_uri: ENV['SLACK_REDIRECT_URI'],
  slack_verification_token: ENV['SLACK_VERIFICATION_TOKEN']
}.freeze

# Quick config check
if SLACK_CONFIG.any? { |_key, value| value.nil? }
  error_msg = missing_params.keys.join(", ").upcase
  raise "Missing Slack config variables: #{error_msg}"
end

def create_slack_client(slack_api_secret)
  # client = Slack::Web::Client.new(token: 'local token')
  Slack.configure do |config|
    config.token = slack_api_secret
    fail 'Missing API token' unless config.token
  end
  Slack::Web::Client.new
end

class Auth < Sinatra::Base
  # landing page with Add to Slack button
  get '/' do
    status 200
    erb :index, locals: { config: SLACK_CONFIG }
  end

  # OAuth Step 2: The user has told Slack that they want to authorize our app to use their account, so
  # Slack sends us a code which we can use to request a token for the user's account.
  get '/finish_auth' do
    client = Slack::Web::Client.new
    # OAuth Step 3: Success or failure
    begin
      response = client.oauth_access(
        {
          client_id: SLACK_CONFIG[:slack_client_id],
          client_secret: SLACK_CONFIG[:slack_api_secret],
          redirect_uri: SLACK_CONFIG[:slack_redirect_uri],
          code: params[:code] # (This is the OAuth code mentioned above)
        }
      )

      # Success! Let's store access_token for this team
      team_id = response['team_id']
      access_token = response['access_token']

      Team.find_or_create_by(external_id: team_id, access_token: access_token)

      redirect '/yay'
    rescue Slack::Web::Api::Error => e
      status 403
      body "Auth failed! Reason: #{e.message}<br/>"
    end
  end

  get '/yay' do

  end
end
