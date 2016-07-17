class QuestionSerializer < ApplicationSerializer
  attributes :body, :id, :title

  belongs_to :user
end
