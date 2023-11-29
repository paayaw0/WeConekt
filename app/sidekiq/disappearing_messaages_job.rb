class DisappearingMessaagesJob
  include Sidekiq::Job

  queue_as :default

  def perform(*_args)
    room_configs = RoomConfiguration.where('disappearing_messages IS NOT NULL')

    room_configs.find_each do |room_config|
      duration = room_config.disappearing_messages
      room = room_config.room

      messages = room.messages.where(updated_at: room_config.updated_at...) # get all room messages post room config set date
      messages_marked_for_deletion = messages.where(updated_at: duration.ago...) # get messages older than duration
      shared_messages = SharedMessage.where(message_id: messages_marked_for_deletion.pluck(:id))
      shared_messages.destroy_all
      messages_marked_for_deletion.destroy_all
    end
  end
end
