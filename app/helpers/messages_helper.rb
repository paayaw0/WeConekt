module MessagesHelper
  def edit_timestamp(message, curren_user)
    return if message.delete_for_everyone? || message.delete_for_current_user_id
    return unless message.created_at != message.updated_at
    return if message.user_id != curren_user.id

    'Edited '
  end

  def message_text(message)
    if message.delete_for_everyone?
      'deleted'
    else
      message.text
    end
  end
end
