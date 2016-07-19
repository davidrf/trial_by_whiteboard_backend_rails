require "rails_helper"

RSpec.describe User do
  subject { build :user }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_secure_password }
  it { should validate_presence_of :authentication_token }
  it { should validate_uniqueness_of :authentication_token }
  it { should validate_presence_of :authentication_token_expires_at }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }

  describe "set_new_unique_authentication_token" do
    let(:first_token) { SecureRandom.base58(24) }
    let(:second_token) { SecureRandom.base58(24) }
    let!(:user) { create(:user, authentication_token: first_token) }
    let(:new_user) do
      build(
        :user,
        authentication_token: nil,
        authentication_token_expires_at: nil
      )
    end

    before :each do
      allow(SecureRandom).to receive(:base58).and_return(
        first_token,
        second_token
      )
      new_user.set_new_unique_authentication_token
    end

    it "should set an authentication token" do
      expect(new_user.authentication_token).to be_a String
    end

    it "should set an authentication token expiration" do
      expect(new_user.authentication_token_expires_at).to be_a ActiveSupport::TimeWithZone
    end

    it "should set a unique authentication token" do
      expect(new_user.authentication_token).to eq second_token
    end
  end
end
