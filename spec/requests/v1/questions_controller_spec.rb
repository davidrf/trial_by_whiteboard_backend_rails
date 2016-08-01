require "rails_helper"

RSpec.describe "Questions controller" do
  describe "#index" do
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

  describe "#show" do
    let!(:question) { create :question }

    it "shows the details of a question" do
      get(question_url(question), headers: accept_header(:v1))

      expect(response).to have_http_status :ok
      expect(response.parsed_body.dig("question", "id")).to be
      expect(response.parsed_body.dig("question", "body")).to eq question.body
      expect(response.parsed_body.dig("question", "title")).to eq question.title
      expect(response.parsed_body.dig("question", "link")).to eq question_url(question)
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
          expect(response.location).to be
          expect(response.parsed_body.dig("question", "id")).to be
          expect(response.parsed_body.dig("question", "body")).to eq question.body
          expect(response.parsed_body.dig("question", "title")).to eq question.title
          expect(response.parsed_body.dig("question", "user", "username")).to eq user.username
          expect(response.parsed_body.dig("question", "link")).to be
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

  describe "#update" do
    let!(:question) { create :question }
    let(:user) { question.user }
    let(:new_title) { "What is love? Baby don't hurt me..." }
    let(:params) do
      {
        question: {
          title: new_title
        }
      }
    end

    context "valid access token" do
      context "valid information for question" do
        it "returns no content" do
          patch(
            question_url(question),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :no_content
        end
      end

      context "invalid information for question" do
        let(:new_title) { "" }
        it "returns error messages" do
          patch(
            question_url(question),
            headers: authorization_headers(:v1, user.authentication_token),
            params: params,
            as: :json
          )

          expect(response).to have_http_status :unprocessable_entity
          expect(response.parsed_body.dig("title", 0)).to eq "can't be blank"
        end
      end

      context "user is not the one who created the question" do
        let(:another_user) { create :user }
        it "returns unauthorized" do
          patch(
            question_url(question),
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
          question_url(question),
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
          question_url(question),
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
          question_url(question),
          headers: authorization_headers(:v1, user.authentication_token),
          params: params,
          as: :json
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "expired"
      end
    end
  end

  describe "#destroy" do
    let!(:question) { create :question }
    let(:user) { question.user }

    context "valid access token" do
      context "user is the one who created the question" do
        it "returns no content" do
          delete(
            question_url(question),
            headers: authorization_headers(:v1, user.authentication_token)
          )

          expect(response).to have_http_status :no_content
        end
      end

      context "user is not the one who created the question" do
        let(:another_user) { create :user }
        it "returns unauthorized" do
          delete(
            question_url(question),
            headers: authorization_headers(:v1, another_user.authentication_token)
          )

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context "no access token" do
      it "returns unauthorized" do
        delete(
          question_url(question),
          headers: accept_header(:v1)
        )

        expect(response).to have_http_status :unauthorized
      end
    end

    context "invalid access token" do
      it "returns unauthorized" do
        delete(
          question_url(question),
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
          question_url(question),
          headers: authorization_headers(:v1, user.authentication_token)
        )

        expect(response).to have_http_status :unauthorized
        expect(response.parsed_body["authentication_token"]).to eq "expired"
      end
    end
  end
end
