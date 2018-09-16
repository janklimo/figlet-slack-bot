require_relative './spec_helper.rb'

describe API do
  describe 'slash command' do
    it 'test' do
      post '/command', { token: 'test token' }.to_json
      expect(last_response).to be_ok
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
