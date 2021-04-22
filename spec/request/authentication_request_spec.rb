require 'rails_helper'

describe 'Whether access is ocurring properly', type: :request do
  before(:all) do
    @current_user = FactoryBot.create(:user)
  end

  context 'context: general authentication via API, ' do
    context "successful login" do
      before(:all) do
        login(@current_user)
        @response_status = response.status
        @json_response = JSON.parse(response.body)
      end

      it 'gives you a status 200 on signing in ' do
        expect(@response_status).to eq(200)
      end

      it 'should have a user object' do
        expect(@json_response).to include("token")
        expect(@json_response).to include("name")
        expect(@json_response).to include("email")
        expect(@json_response).to include("id")
      end

      it 'should update the last_login attribute on the account' do
        expect(User.find(@current_user.id).last_login).not_to be_nil
      end
    end

    context 'unsuccessful login' do
      before(:all) do
        login(FactoryBot.build(:user))
        @response_status = response.status
        @json_response = JSON.parse(response.body)
      end

      it 'gives you a status 404 of account not found' do
        expect(@response_status).to eq(422)
      end

      it 'should have a message' do
        expect(@json_response).to include("messages")
      end

    end

    it "doesn't give you anything if you don't log in" do
      get products_path()
      expect(response.status).to eq(401)
    end

    it "responds with status :ok after login" do
      login(@current_user)

      get products_path, headers: get_auth_header(response)
      expect(response.status).to eq(200)
    end
  end
end
