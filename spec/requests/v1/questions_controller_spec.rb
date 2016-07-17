require "rails_helper"

RSpec.describe "Questions controller" do
  describe "#index" do
    let!(:user) { create :user }
    let!(:questions) { create_list :question, 2 }

    it "shows a list of questions" do
      get(questions_url, headers: accept_header(:v1))

      expect(response).to have_http_status :ok
      question_titles = response.parsed_body["questions"].map do |question|
        question["title"]
      end
      expected_question_titles = questions.map(&:title)
      expect(question_titles).to include(*expected_question_titles)
    end
  end

  describe "#create" do
    let!(:user) { create :user }
    let(:params) do
      {
        question: {
          body: question.body,
          title: question.title
        }
      }
    end

    context "valid access token" do
      context "valid information for question" do
        let(:question) { build :question }
        it "returns JSON for question" do
          post(
            questions_url,
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :created
          expect(response.parsed_body.dig("question", "id")).to be
          expect(response.parsed_body.dig("question", "body")).to eq question.body
          expect(response.parsed_body.dig("question", "title")).to eq question.title
          expect(response.parsed_body.dig("question", "user", "username")).to eq user.username
        end
      end

      context "question without anything specified" do
        let(:question) { build :question, title: nil, body: nil }
        it "returns error messages" do
          post(
            questions_url,
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(response.parsed_body.dig("title", 0)).to eq "can't be blank"
          expect(response.parsed_body.dig("body", 0)).to eq "can't be blank"
        end
      end

      context "question with title that already exists" do
        let!(:existing_question) { create :question }
        let(:question) { build :question, title: existing_question.title }
        it "returns error messages" do
          post(
            questions_url,
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(response.parsed_body.dig("title", 0)).to eq "has already been taken"
        end
      end
    end

    context "no access token" do
      let(:question) { build :question }
      it "returns unauthorized" do
        post(
          questions_url,
          headers: accept_header(:v1),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "not specified"
      end
    end

    context "invalid access token" do
      let(:question) { build :question }
      it "returns unauthorized" do
        post(
          questions_url,
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
      let(:question) { build :question }
      it "returns unauthorized" do
        post(
          questions_url,
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
