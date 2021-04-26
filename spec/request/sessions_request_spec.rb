require 'rails_helper'
RSpec.describe "Sessions", type: :request do
    describe "POST /login" do
        context "valid credentials" do
            before(:all) do
                @user = FactoryBot.create :user
                post "/login", params: { auth: { email: @user.email, password: @user.password } }
                @response_data = JSON.parse(response.body)
            end

            it "should respond with :ok" do
                expect(response.status).to eq 200
            end

            it "should return a jwt for the user" do
                expect(@response_data).to have_key("token")
            end

            it "should have a valid JWT Token" do
                user = User.find(@response_data["id"])
                user.valid_until = user.last_login + 30.minutes
                user.generate_token
                expect(@response_data["token"]).to eq user.token
            end

            it "should update the user last_login" do
                expect(@response_data["last_login"]).not_to be_nil
            end
        end
        context "invalid credentials" do
            before(:all) do
                @user = FactoryBot.create :user
                post "/login", params: { auth: { email: @user.email, password: "NO ES" } }
                @response_data = JSON.parse(response.body)
            end
            it "should respond with :unprocessable_entity" do
                expect(response.status).to eq 422
            end
            it "should return an error message with 'invalid_credentials'" do
                expect(@response_data["messages"]).to include I18n.t("error.messages.invalid_credentials")
            end
        end
    end

    describe "POST /persist" do
        before(:all) do
            @current_user = FactoryBot.create :user
            login(@current_user)
            @first_response = JSON.parse(response.body)
            @first_auth_token = @first_response["token"]
            @auth_headers = get_auth_header(response)
            sleep 1
            post "/persist", headers: @auth_headers
            @response_data = JSON.parse(response.body)
        end

        it "should have a new token" do
            expect(@response_data).to have_key("token")
            expect(@response_data["token"]).not_to eq @first_auth_token
        end

        it "should be able to access an authenticated resource with that new token" do
            get products_path, headers: get_auth_header(response)

            expect(response.status).to eq 200
        end
    end
end
