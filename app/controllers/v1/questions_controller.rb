class V1::QuestionsController < V1::ApplicationController
  def create
    question = Question.new(question_params)
    question.user = current_user
    if question.save
      render json: question, status: :created
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
