# spec/features/offerings_spec.rb

require 'rails_helper'

RSpec.feature "Offerings Management", type: :feature do
  let!(:user) { create(:user, email: 'testuser@visitmeet.com', password: 'password') }
  let!(:other_user) { create(:user, email: 'otheruser@visitmeet.com', password: 'password') }

  before do
    login_as(user, scope: :user)
  end

  scenario "User creates a valid offering" do
    visit new_offering_path

    fill_in "Title", with: "Photography Tour"
    fill_in "Description", with: "Explore hidden photography spots."
    fill_in "Price", with: "50"
    fill_in "Location", with: "Paris"

    click_button "Create Offering"

    expect(page).to have_content("Offering created successfully!")
    expect(page).to have_content("Photography Tour")
    expect(page).to have_content("$50.0")
  end

  scenario "User sees validation errors when creating invalid offering" do
    visit new_offering_path

    click_button "Create Offering"

    expect(page).to have_content("Please fix the following errors")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price can't be blank")
    expect(page).to have_content("Location can't be blank")
  end

  scenario "User edits an existing offering" do
    offering = create(:offering, user: user, title: "Original Tour")

    visit edit_offering_path(offering)

    fill_in "Title", with: "Updated Tour"
    click_button "Update Offering"

    expect(page).to have_content("Offering updated successfully!")
    expect(page).to have_content("Updated Tour")
    expect(page).not_to have_content("Original Tour")
  end

  scenario "User cannot edit another user's offering" do
    other_offering = create(:offering, user: other_user, title: "Other User's Tour")

    visit edit_offering_path(other_offering)

    expect(page).to have_content("You can only edit your own offerings.")
  end

  scenario "User deletes an offering" do
    offering = create(:offering, user: user, title: "Deletable Tour")

    visit offerings_path

    click_link "Delete", match: :first

    expect(page).to have_content("Offering deleted successfully!")
    expect(page).not_to have_content("Deletable Tour")
  end

  scenario "User sees all their offerings listed" do
    create(:offering, user: user, title: "Tour 1")
    create(:offering, user: user, title: "Tour 2")

    visit offerings_path

    expect(page).to have_content("Tour 1")
    expect(page).to have_content("Tour 2")
  end
end