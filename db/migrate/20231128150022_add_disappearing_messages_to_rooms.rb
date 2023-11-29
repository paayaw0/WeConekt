class AddDisappearingMessagesToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :disappearing_messages, :interval
  end
end
