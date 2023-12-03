module MessagesHelper
  def edit_timestamp(message)
    return if message.delete_for_everyone? || message.delete_for_current_user_id
    return unless message.created_at != message.updated_at

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
