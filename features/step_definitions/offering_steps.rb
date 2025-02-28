Given("I am logged in") do
  @user = FactoryBot.create(:user, email: "test@example.com", password: "password")
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Log in"
end

When("I visit the new offering page") do
  visit new_offering_path
end

When("I fill in the offering details") do
  fill_in "Title", with: "Secret Waterfall Tour"
  fill_in "Description", with: "A hidden gem in the woods"
  fill_in "Price", with: "10"
  fill_in "Location", with: "Wildwood Forest"
end

When("I submit the form") do
  click_button "Create Offering"
end

Then("I should see my offering on my profile") do
  visit user_path(@user)
  expect(page).to have_content("Secret Waterfall Tour")
  expect(page).to have_content("$10")
end