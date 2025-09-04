require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followed).class_name('User') }
  end

  describe "validations" do
    subject { create(:follow) }
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

    it "does not allow a user to follow themselves" do
      user = create(:user)
      follow = build(:follow, follower: user, followed: user)

      expect(follow).not_to be_valid
      expect(follow.errors[:followed_id]).to include("can't be the same as follower")
    end
  end
end