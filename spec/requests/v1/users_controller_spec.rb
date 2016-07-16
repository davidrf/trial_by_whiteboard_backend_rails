require "rails_helper"

RSpec.describe "Users controller" do
  describe "#create" do
    let!(:existing_user) { create(:user) }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password,
          username: user.username
        }
      }
    end

    context "new user with valid information" do
      let(:user) { build(:user) }

      it "returns JSON for a user" do
        post(
          users_url,
          headers: { "Accept" => Mime[:v1].to_s },
          params: params,
          as: :json
        )

        expect(response).to have_http_status :created
        expect(response.parsed_body.dig("user", "id")).to be
        expect(response.parsed_body.dig("user", "email")).to eq user.email
        expect(response.parsed_body.dig("user", "username")).to eq user.username
        expect(response.parsed_body.dig("user", "authenticationToken")).to be
        expect(response.parsed_body.dig("user", "authenticationTokenExpiresAt")).to be
      end
    end

    context "new user with email that already exists" do
      let(:user) { build(:user, email: existing_user.email) }

      it "returns error messages" do
        post(
          users_url,
          headers: { "Accept" => Mime[:v1].to_s },
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(response.parsed_body.dig("email", 0)).to eq "has already been taken"
      end
    end

    context "new user with username that already exists" do
      let(:user) { build(:user, username: existing_user.username) }

      it "returns error messages" do
        post(
          users_url,
          headers: { "Accept" => Mime[:v1].to_s },
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(response.parsed_body.dig("username", 0)).to eq "has already been taken"
      end
    end

    context "new user without anything specified" do
      let(:user) { build(:user, email: nil, password: nil, username: nil) }

      it "returns error messages" do
        post(
          users_url,
          headers: { "Accept" => Mime[:v1].to_s },
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unprocessable_entity
        expect(response.parsed_body.dig("email", 0)).to eq "can't be blank"
        expect(response.parsed_body.dig("password", 0)).to eq "can't be blank"
        expect(response.parsed_body.dig("username", 0)).to eq "can't be blank"
      end
    end
  end
end
