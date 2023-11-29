class CreateRoomConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :room_configurations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.interval :disappearing_messages
      t.boolean :chat_lock_enabled
      t.string :chat_lock_token

      t.timestamps
    end
  end
end
