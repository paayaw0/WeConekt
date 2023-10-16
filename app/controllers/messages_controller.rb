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
    @message.destroy
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

  def update_message_params
    params.require(:message).permit(:text)
  end
end
