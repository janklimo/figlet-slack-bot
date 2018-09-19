# frozen_string_literal: true

require 'figlet'
require_relative './emoji_machine'

class API < Sinatra::Base
  # testing only
  get '/demo' do
    font = Figlet::Font.new(font_path('banner'))
    figlet = Figlet::Typesetter.new(font)
    status 200
    body figlet[params['text']]
      .gsub!('#', ":#{params['one']}:")
      .gsub!(' ', ":#{params['two']}:")
  end

  # production
  # payload:
  # {
  #   "token"=>"o8oredactedgjqc",
  #   "team_id"=>"T0redactedE8",
  #   "team_domain"=>"domain",
  #   "channel_id"=>"channel_id",
  #   "channel_name"=>"directmessage",
  #   "user_id"=>"U03S4redactedG",
  #   "user_name"=>"user",
  #   "command"=>"/figlet",
  #   "text"=>"100",
  #   "response_url"=>"https://hooks.slack.com/Mredactedl0xlYHx",
  #   "trigger_id"=>"435641testtesttest3b0b0710d"
  # }
  post '/command' do
    STDERR.puts params unless ENV['RACK_ENV'] == 'test'

    # validate the request comes from Slack
    unless SLACK_CONFIG[:slack_verification_token] == params['token']
      halt 403, "Invalid Slack verification token received: #{params['token']}"
    end

    # help command
    if params['text'].squish == 'help'
      status 200
      return 'Need help? No worries :hugging_face: Visit https://figlet.fun/help ' \
        'to learn everything about using Figlet with Slack!'
    end

    machine = EmojiMachine.new(params['text'])

    # user forgot to provide text
    if machine.text.blank?
      status 200
      return 'Oops! That command did not contain any text :sweat_smile:' \
        'Visit https://figlet.fun/help to learn everything about ' \
        'using Figlet with Slack!'
    end

    team = Team.find_by_external_id(params['team_id'])
    client = Slack::Web::Client.new(token: team.access_token)

    client.chat_postMessage(
      channel: params['channel_id'],
      text: machine.generate_text
    )

    status 200
  end

  get '/privacy' do
    erb :privacy
  end

  get '/help' do
    erb :help
  end
end
