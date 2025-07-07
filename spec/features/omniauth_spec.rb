require 'rails_helper'

RSpec.feature "Omniauth", type: :feature do
  scenario "User can sign in with Google" do
    mock_auth_hash(:google_oauth2)
    visit new_user_session_path
    click_link "Sign in with Google"

    expect(page).to have_content("Successfully authenticated from Google account.")
    expect(page).to have_link("My Profile")
    expect(User.last.email).to eq("test@example.com")
  end

  scenario "User can sign in with Facebook" do
    mock_auth_hash(:facebook)
    visit new_user_session_path
    click_link "Sign in with Facebook"

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    expect(page).to have_link("My Profile")
    expect(User.last.email).to eq("test@example.com")
  end
end
