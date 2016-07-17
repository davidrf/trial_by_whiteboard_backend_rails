class AnswerSerializer < ApplicationSerializer
  attributes :body, :id, :link

  belongs_to :question
  belongs_to :user

  def link
    answer_url(object)
  end
end
