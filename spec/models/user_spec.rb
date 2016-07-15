require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }
  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
end
