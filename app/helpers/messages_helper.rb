module MessagesHelper
  def edit_timestamp(message)
    if message.created_at != message.updated_at
      'Edited '
    end
  end
end
