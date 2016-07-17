class UserSerializer < ApplicationSerializer
  attributes :id, :username

  has_many :questions
end
