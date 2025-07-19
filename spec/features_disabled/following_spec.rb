require 'rails_helper'

RSpec.describe "Following", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    driven_by(:selenium, using: :firefox)
    login_as(user, scope: :user)
  end

  it "allows a user to follow another user" do
    visit user_path(other_user)

    expect(page).to have_content("Followers 0")
    expect(page).to have_content("Following 0")

    click_button "Follow"

    expect(page).to have_content("Followers 1")
    expect(page).to have_content("Following 0")
    expect(page).to have_button("Unfollow")
  end

  it "allows a user to unfollow another user" do
    user.follow(other_user)

    visit user_path(other_user)

    expect(page).to have_content("Followers 1")
    expect(page).to have_content("Following 0")

    click_button "Unfollow"

    expect(page).to have_content("Followers 0")
    expect(page).to have_content("Following 0")
    expect(page).to have_button("Follow")
  end
end