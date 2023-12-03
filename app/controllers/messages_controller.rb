class MessagesController < ApplicationController
  before_action :set_message, only: %i[edit update destroy]

  def create
    Message.create(message_params)
    room = Room.find_by(id: message_params[:room_id])
    set_current_room(room)
  end

  def edit; end

  def update
    @message.update(update_message_params)
  end

  def destroy
    delete_for_everyone = delete_options_params[:delete_for_everyone] == '1'

    if delete_for_everyone || @message.delete_for_current_user_id
      redacted_text = @message.text.gsub(/./, '*')
      @message.update(text: redacted_text, delete_for_everyone: true) # redacts text for object globally
    elsif delete_options_params[:delete_for_current_user_id] == '1'
      @message.update(delete_for_current_user_id: current_user.id) # used to redact text in views
    end
  end

  def delete_message_options
    @message = Message.find_by(id: params[:message_id])
  end

  def cancel
    message = Message.find(params[:message_id])

    message.broadcast_replace_to(
      [:room, message.room&.id],
      target: message,
      partial: 'messages/message',
      locals: {
        message:
      }
    )
  end

  private

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def message_params
    params.permit(
      :text,
      :room_id,
      :user_id
    )
  end

  def delete_options_params
    params.require(:message).permit(
      :delete_for_everyone,
      :delete_for_current_user_id,
      :current_user_id
    )
  end

  def update_message_params
    params.require(:message).permit(:text)
  end
end
