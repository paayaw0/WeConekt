class MessagesController < ApplicationController
  def create
    Message.create(message_params)  
  end

  private

  def message_params
    params.permit(
      :text,
      :connection_id,
      :room_id,
      :user_id
    )
  end
end
