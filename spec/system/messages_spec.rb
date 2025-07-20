require 'rails_helper'

RSpec.describe "Messages", type: :system do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
    @conversation = create(:conversation, sender: @user1, recipient: @user2)

    sign_in @user1
    visit conversation_messages_path(@conversation)
  end

  it "sends a message by pressing Enter", driver: :selenium_firefox do
    fill_in "message_body", with: "Hello, user2!"
    find("#message_body").send_keys(:enter)

    expect(page).to have_content("Hello, user2!")
    expect(page).to have_css(".message-row.sent .message-bubble", text: "Hello, user2!")
  end

  it "sends a message by clicking the Send button", js: true do
    fill_in "message_body", with: "Hello again, user2!"
    click_button "Send"

    expect(page).to have_content("Hello again, user2!")
    expect(page).to have_css(".message-row.sent .message-bubble", text: "Hello again, user2!")
  end

  it "clears the message input after sending", js: true do
    fill_in "message_body", with: "This should clear."
    find("#message_body").send_keys(:enter)

    expect(page).to have_field("message_body", with: "")
  end

  it "auto-resizes the message input field", js: true do
    # Fill with a short message, check height
    fill_in "message_body", with: "Short message"
    initial_height = find("#message_body").native.size.height

    # Fill with a long message that should wrap, check height increase
    long_message = "a\n" * 10 # 10 lines
    fill_in "message_body", with: long_message
    long_message_height = find("#message_body").native.size.height

    expect(long_message_height).to be > initial_height
  end
end
