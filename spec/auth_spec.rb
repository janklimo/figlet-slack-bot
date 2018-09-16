require_relative './spec_helper.rb'

describe Auth do
  it 'allows accessing the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  describe 'OAuth' do
    before do
      successful_hash = {
        'team_id' => 'new team',
        'access_token' => 'fresh token'
      }
      allow_any_instance_of(Slack::Web::Client).to receive(:oauth_access)
        .and_return successful_hash
    end

    context 'new team installation' do
      it 'creates the team' do
        get '/finish_auth'
        expect(Team.count).to eq 1

        new_team = Team.last
        expect(new_team.external_id).to eq 'new team'
        expect(new_team.access_token).to eq 'fresh token'
        expect(last_response).to be_redirect
      end
    end

    context 'a returning team' do
      it 'updates the team' do
        Team.create(external_id: 'new team', access_token: 'old token')

        get '/finish_auth'
        expect(Team.count).to eq 1

        old_team = Team.last
        expect(old_team.external_id).to eq 'new team'
        expect(old_team.access_token).to eq 'fresh token'
        expect(last_response).to be_redirect
      end
    end
  end
end