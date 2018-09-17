# frozen_string_literal: true

require 'figlet'

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

    team = Team.find_by_external_id(params['team_id'])
    client = Slack::Web::Client.new(token: team.access_token)

    client.chat_postMessage(
      channel: params['channel_id'],
      text: EmojiMachine.new(params['text']).generate_text,
    )

    status 200
  end
end

class EmojiMachine
  attr_accessor :text, :figlet

  FIGLET_BODY_DEFAULT = ':100:'
  FIGLET_BACKGROUND_DEFAULT = ':cloud:'

  def initialize(text)
    font = Figlet::Font.new(font_path('banner'))
    @figlet = Figlet::Typesetter.new(font)
    @text = text
  end

  def generate_text
    # the first emoji given becomes text body, the second one background
    emoji = text.scan(/:\w+:/).flatten

    # keep the text itself only
    text.gsub!(/:\w+:/, '')&.squish

    figlet[text]
      .gsub!('#', emoji[0] || FIGLET_BODY_DEFAULT)
      .gsub!(' ', emoji[1] || FIGLET_BACKGROUND_DEFAULT)
  end

  private

  def font_path(font_name)
    File.join(File.dirname(__FILE__), 'fonts', "#{font_name}.flf")
  end
end
