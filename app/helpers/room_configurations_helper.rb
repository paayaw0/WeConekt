module RoomConfigurationsHelper
  def selected_disappearing_messages_duration(user_id, room_id)
    room_config = RoomConfiguration.find_by(user_id:, room_id:)

    return 0 if room_config.nil?

    room_config.disappearing_messages.nil? ? 0 : room_config.disappearing_messages
  end
end
