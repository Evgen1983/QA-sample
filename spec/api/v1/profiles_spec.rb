require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    
    it_behaves_like "API Authenticable"
    def do_request(options = {})
      get "/api/v1/profiles/me", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
    
  end


  describe 'GET /index' do
    it_behaves_like "API Authenticable"
    def do_request(options = {})
      get "/api/v1/profiles", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 4) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"

      it 'contains array of users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'doesnt contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, i|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{i}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          users.each_with_index do |user, i|
            expect(response.body).to_not have_json_path("#{i}/#{attr}")
          end
        end
      end
    end
  end
end