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
        'access_token' => 'fresh token',
        'team_name' => 'Lockstep Labs'
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
        expect(new_team.name).to eq 'Lockstep Labs'
        expect(last_response).to be_redirect
        expect(last_response.header['Location'])
          .to include "yay?team_name=Lockstep Labs"
      end
    end

    context 'a returning team' do
      it 'updates the team' do
        Team.create(external_id: 'new team', access_token: 'old token',
                   name: 'Old Name')

        get '/finish_auth'
        expect(Team.count).to eq 1

        old_team = Team.last
        expect(old_team.external_id).to eq 'new team'
        expect(old_team.access_token).to eq 'fresh token'
        expect(old_team.name).to eq 'Lockstep Labs'
        expect(last_response).to be_redirect
        expect(last_response.header['Location'])
          .to include "yay?team_name=Lockstep Labs"
      end
    end
  end
end
