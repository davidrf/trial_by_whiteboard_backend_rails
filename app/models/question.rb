class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true
  validates :user, presence: true
end
