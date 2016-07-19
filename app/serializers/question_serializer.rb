class QuestionSerializer < ApplicationSerializer
  attributes :body, :id, :title, :link

  belongs_to :user
  has_many :answers

  def link
    question_url(object)
  end
end
