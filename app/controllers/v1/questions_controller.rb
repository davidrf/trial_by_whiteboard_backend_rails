class V1::QuestionsController < V1::ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]

  def index
    @questions = Question.all
    render json: @questions, status: :ok
  end

  def show
    render json: @question, status: :ok
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      head :no_content
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def authorize_user
    head :unauthorized if @question.user != current_user
  end
end
