require File.expand_path './spec_helper.rb', __dir__

describe Auth do
  it 'allows accessing the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  describe 'OAuth' do
    context 'new team installation' do
      before do
        successful_hash = {
          'team_id' => 'new team',
          'access_token' => 'new token'
        }
        allow_any_instance_of(Slack::Web::Client).to receive(:oauth_access)
          .and_return successful_hash
      end

      it 'creates the team' do
        get '/finish_auth'
        expect(last_response).to be_redirect
      end
    end
  end
end
