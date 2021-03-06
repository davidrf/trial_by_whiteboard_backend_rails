require "rails_helper"

RSpec.describe Answer do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should validate_presence_of :user }
end
