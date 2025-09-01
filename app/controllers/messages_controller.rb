class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @messages = @conversation.messages.includes(:user)
    @messages.unread.where.not(user: current_user).update_all(read_at: Time.current)
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      @conversation.update(typing_user_id: nil)
      respond_to do |format|
        format.html { redirect_to conversation_messages_path(@conversation) }
        format.turbo_stream do
          Turbo::StreamsChannel.broadcast_append_to @conversation, target: "messages", partial: "messages/message", locals: { message: @message, is_current_user_message: (@message.user == current_user), new_message: true }
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { conversation: @conversation, message: Message.new })
        end
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless @message.user == current_user

    @message.destroy
    Turbo::StreamsChannel.broadcast_remove_to @conversation, target: helpers.dom_id(@message)

    respond_to do |format|
      format.html { redirect_to conversation_messages_path(@conversation), notice: "Message deleted." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
    end
  end

  def edit
    return head :forbidden unless @message.user == current_user
  end

  def update
    return head :forbidden unless @message.user == current_user

    if @message.update(message_params)
      Turbo::StreamsChannel.broadcast_replace_to @conversation, target: helpers.dom_id(@message), partial: "messages/message", locals: { message: @message, is_current_user_message: (@message.user == current_user) }

      respond_to do |format|
        format.html { redirect_to conversation_messages_path(@conversation), notice: "Message updated." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@message, partial: "messages/message", locals: { message: @message, is_current_user_message: true })
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def set_message
    @message = @conversation.messages.find(params[:id])
  end
end
