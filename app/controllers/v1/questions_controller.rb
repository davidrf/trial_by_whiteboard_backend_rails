class V1::QuestionsController < V1::ApplicationController
  def index
    questions = Question.all
    render json: questions, status: :ok
  end

  def show
    question = Question.find(params[:id])
    render json: question, status: :ok
  end

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
