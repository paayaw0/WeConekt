class PreventEditDeleteMessageActionTimeWindowJob
  include Sidekiq::Job

  def perform
    Message.find_each do |message|
      next if message.able_to_edit_or_delete?

      message.broadcast_replace_to(
        "online_users_rooms_id_#{message.room_id}",
        target: "toggle_edit_delete_#{message.id}",
        partial: 'users/toggle_edit_delete_action',
        locals: {
          message: message
        }
      )
    end
  end
end
