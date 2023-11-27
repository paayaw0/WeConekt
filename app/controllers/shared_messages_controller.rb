class SharedMessagesController < ApplicationController
  def new
    @message = Message.find(params[:message_id])
  end

  def create
    return if shared_message_params[:rooms] == ['']

    shared_message = SharedMessage.new(shared_message_params.to_h.except(:rooms))
    rooms = Room.where(id: params[:shared_message][:rooms])
    shared_message.rooms << rooms
    shared_message.save
  end

  private

  def shared_message_params
    params.require(:shared_message).permit(
      :room_id,
      :message_id,
      :user_id,
      rooms: []
    )
  end
end
