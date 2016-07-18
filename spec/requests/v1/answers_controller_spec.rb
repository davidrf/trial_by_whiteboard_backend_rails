require "rails_helper"

RSpec.describe "Answers controller" do
  describe "#create" do
    let!(:question) { create :question }
    let!(:user) { create :user }
    let(:params) do
      {
        answer: {
          body: answer.body
        }
      }
    end

    context "valid access token" do
      context "valid information for the answer" do
        let(:answer) { build :answer }
        it "returns JSON for question" do
          post(
            question_answers_url(question),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :created
          expect(response.location).to be
          expect(response.parsed_body.dig("answer", "id")).to be
          expect(response.parsed_body.dig("answer", "body")).to eq answer.body
          expect(response.parsed_body.dig("answer", "link")).to be
        end
      end

      context "answer without anything specified" do
        let(:answer) { build :answer, body: nil }
        it "returns error messages" do
          post(
            question_answers_url(question),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(response.parsed_body.dig("body", 0)).to eq "can't be blank"
        end
      end
    end

    context "no access token" do
      let(:answer) { build :answer }
      it "returns unauthorized" do
        post(
          question_answers_url(question),
          headers: accept_header(:v1),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
      end
    end

    context "invalid access token" do
      let(:answer) { build :answer }
      it "returns unauthorized" do
        post(
          question_answers_url(question),
          headers: authorization_headers(:v1, ""),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "not found"
      end
    end

    context "expired access token" do
      let!(:user) { create :user, authentication_token_expires_at: Time.current }
      let(:answer) { build :answer }
      it "returns unauthorized" do
        post(
          question_answers_url(question),
          headers: authorization_headers(:v1, user.authentication_token),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "expired"
      end
    end
  end

  describe "#update" do
    let!(:answer) { create :answer }
    let(:user) { answer.user }
    let(:new_body) { "Did you turn it off and turn it back on?" }
    let(:params) do
      {
        answer: {
          body: new_body
        }
      }
    end

    context "valid access token" do
      context "valid information for answer" do
        it "returns no content" do
          patch(
            answer_url(answer),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :no_content
        end
      end

      context "invalid information for answer" do
        let(:new_body) { "" }
        it "returns error messages" do
          patch(
            answer_url(answer),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(response.parsed_body.dig("body", 0)).to eq "can't be blank"
        end
      end

      context "user is not the one who created the question" do
        let(:another_user) { create :user }
        it "returns unauthorized" do
          patch(
            answer_url(answer),
            headers: authorization_headers(:v1, another_user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context "no access token" do
      it "returns unauthorized" do
        patch(
          answer_url(answer),
          headers: accept_header(:v1),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
      end
    end

    context "invalid access token" do
      it "returns unauthorized" do
        patch(
          answer_url(answer),
          headers: authorization_headers(:v1, ""),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "not found"
      end
    end

    context "expired access token" do
      let!(:user) { create :user, authentication_token_expires_at: Time.current }
      it "returns unauthorized" do
        patch(
          answer_url(answer),
          headers: authorization_headers(:v1, user.authentication_token),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "expired"
      end
    end
  end
end
