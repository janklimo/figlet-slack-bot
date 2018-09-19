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

    it 'handles texts with emoji included' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: 'hello :100: :rocket:', channel_id: 'social'}
      expect(last_response).to be_ok
    end

    it 'understands help command' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: 'help ', channel_id: 'social'}
      expect(last_response).to be_ok
      expect(last_response.body).to include 'Need help?'
    end
  end
end
