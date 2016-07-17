class Question < ApplicationRecord
  belongs_to :user

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true
  validates :user, presence: true
end
