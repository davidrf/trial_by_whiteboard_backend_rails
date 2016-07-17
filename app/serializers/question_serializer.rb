class QuestionSerializer < ApplicationSerializer
  attributes :body, :id, :title, :link

  belongs_to :user

  def link
    question_url(object)
  end
end
