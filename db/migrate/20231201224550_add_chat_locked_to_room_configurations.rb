class AddChatLockedToRoomConfigurations < ActiveRecord::Migration[7.0]
  def change
    add_column :room_configurations, :chat_locked, :boolean, default: false
    remove_column :room_configurations, :chat_lock_enabled
    remove_column :room_configurations, :chat_lock_token
  end
end
