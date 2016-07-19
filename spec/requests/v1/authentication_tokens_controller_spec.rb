require "rails_helper"

RSpec.describe "Authentication Tokens controller" do
  describe "#create" do
    let!(:user) { create :user }
    let(:password) { user.password }
    let(:params) do
      {
        user: {
          username: user.username,
          password: password,
        }
      }
    end

    context "valid user credentials" do
      it "returns authenticated JSON for user" do
        post(
          authentication_tokens_url,
          headers: accept_header(:v1),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :ok
        expect(response.parsed_body.dig("user", "authenticationToken")).to be
        expect(response.parsed_body.dig("user", "authenticationToken")).to_not eq user.authentication_token
        expect(response.parsed_body.dig("user", "authenticationTokenExpiresAt")).to be
        expect(response.parsed_body.dig("user", "authenticationTokenExpiresAt")).to_not eq user.authentication_token_expires_at
        expect(response.parsed_body.dig("user", "email")).to eq user.email
        expect(response.parsed_body.dig("user", "id")).to eq user.id
        expect(response.parsed_body.dig("user", "username")).to eq user.username
      end
    end

    context "non-existing user" do
      let(:user) { build :user }
      it "returns error messages" do
        expect do
          post(
            authentication_tokens_url,
            headers: accept_header(:v1),
            params: params,
            as: :json
          )
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "invalid password" do
      let(:password) { "password1" }
      it "returns error messages" do
        post(
          authentication_tokens_url,
          headers: accept_header(:v1),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "#destroy" do
    let!(:user) { create :user }

    context "valid access token" do
      it "returns no content and expires the user's token" do
        delete(
          authentication_tokens_url,
          headers: authorization_headers(:v1, user.authentication_token)
        )

        expect(response).to have_http_status :no_content
        expect(user.reload.authentication_token_expires_at).to be <= Time.current
      end
    end

    context "no access token" do
      it "returns unauthorized" do
        delete(
          authentication_tokens_url,
          headers: accept_header(:v1)
        )

        expect(response).to have_http_status :unauthorized
      end
    end

    context "invalid access token" do
      it "returns unauthorized" do
        delete(
          authentication_tokens_url,
          headers: authorization_headers(:v1, "")
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "not found"
      end
    end

    context "expired access token" do
      let!(:user) { create :user, authentication_token_expires_at: Time.current }
      it "returns unauthorized" do
        delete(
          authentication_tokens_url,
          headers: authorization_headers(:v1, user.authentication_token)
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "expired"
      end
    end
  end
end
