module MessagesHelper
  def edit_timestamp(message)
    if message.created_at != message.updated_at
      'Edited '
    end
  end

  def can_user_delete_message?(message)
    message.seen_at
  end
end
