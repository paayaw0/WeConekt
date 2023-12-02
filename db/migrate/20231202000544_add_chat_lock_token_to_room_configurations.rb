class AddChatLockTokenToRoomConfigurations < ActiveRecord::Migration[7.0]
  def change
    add_column :room_configurations, :chat_lock_token, :string, default: nil
  end
end
