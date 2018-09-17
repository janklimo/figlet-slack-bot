require_relative './spec_helper.rb'

describe API do
  describe 'slash command' do
    it 'sends a response to the right team and channel' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: 'hello', channel_id: 'social'}
      expect(last_response).to be_ok
    end
  end
end
