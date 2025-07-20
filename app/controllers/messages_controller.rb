class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def index
    @messages = @conversation.messages.includes(:user)
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to conversation_messages_path(@conversation) }
        format.turbo_stream do
          Turbo::StreamsChannel.broadcast_append_to @conversation, target: "messages", partial: "messages/message", locals: { message: @message, is_current_user_message: (@message.user == current_user) }
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { conversation: @conversation, message: Message.new })
        end
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
