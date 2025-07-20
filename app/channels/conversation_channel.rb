class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    stream_for Conversation.find(params[:conversation_id])
  end

  def unsubscribed
    stop_all_streams
  end

  def typing(data)
    conversation = Conversation.find(params[:conversation_id])
    conversation.update(typing_user_id: data['typing_user_id'])
  end

  def stopped_typing(data)
    conversation = Conversation.find(params[:conversation_id])
    conversation.update(typing_user_id: nil)
  end
end