Given('a user exists with email {string} and password {string}') do |email, password|
  @user = User.create!(email: email, password: password, password_confirmation: password)
end

Given('I am logged in as {string}') do |email|
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Given('the user has a tag {string}') do |tag_name|
  @user.tags.create!(name: tag_name)
end

When('I visit the profile page of the user') do
  visit profile_path(@user)
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I press {string}') do |button|
  click_button button
end

When('I click the remove button for {string}') do |tag_name|
  tag = Tag.find_by(name: tag_name)
  find("button[data-tag-id='#{tag.id}']").click
end

Then('I should see {string} in the list of tags') do |tag_name|
  expect(page).to have_content(tag_name)
end

Then('I should not see {string} in the list of tags') do |tag_name|
  expect(page).not_to have_content(tag_name)
end
