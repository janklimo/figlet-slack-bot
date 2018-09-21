require_relative './spec_helper.rb'

describe API do
  describe 'slash command' do
    it 'sends a response to the right team and channel' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: 'hello', channel_id: 'social'}
      # empty 200 response
      expect(last_response).to be_ok
      expect(last_response.header['Content-Length']).to eq '0'
    end

    it 'handles texts with emoji included' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: 'hello :100: :rocket:', channel_id: 'social'}
      # empty 200 response
      expect(last_response).to be_ok
      expect(last_response.header['Content-Length']).to eq '0'
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

    it 'catches when no text (only emoji) is given' do
      Team.create(external_id: 'new team', access_token: 'test token')

      stub_request(:post, "https://slack.com/api/chat.postMessage").
        with(body: hash_including(channel: 'social', token: 'test token'))
      post '/command', { token: 'test token', team_id: 'new team',
                         text: ':racing_car: :white_small_square:', channel_id: 'social'}
      expect(last_response).to be_ok
      expect(last_response.body).to include 'did not contain any text'
    end
  end
end
