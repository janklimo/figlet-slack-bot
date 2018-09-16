# frozen_string_literal: true

SLACK_CONFIG = {
  slack_client_id: ENV['SLACK_CLIENT_ID'],
  slack_api_secret: ENV['SLACK_API_SECRET'],
  slack_redirect_uri: ENV['SLACK_REDIRECT_URI'],
  slack_verification_token: ENV['SLACK_VERIFICATION_TOKEN']
}.freeze

# Quick config check
if SLACK_CONFIG.any? { |_key, value| value.nil? }
  error_msg = SLACK_CONFIG.select { |_k, v| v.nil? }.keys.join(", ").upcase
  raise "Missing Slack config variables: #{error_msg}"
end

class Auth < Sinatra::Base
  # landing page with Add to Slack button
  get '/' do
    status 200
    erb :index, locals: { config: SLACK_CONFIG }
  end

  # OAuth flow
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

      # if it's a returning team, let's update the token instead
      if team = Team.find_by_external_id(team_id)
        team.update(access_token: access_token)
      else
        Team.create(external_id: team_id, access_token: access_token)
      end

      redirect '/yay'
    rescue Slack::Web::Api::Error => e
      status 403
      body "Auth failed! Reason: #{e.message}<br/>"
    end
  end

  get '/yay' do

  end
end
