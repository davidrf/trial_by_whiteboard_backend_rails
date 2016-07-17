
require "rails_helper"

RSpec.describe Question do
  subject { build :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :user }
end
