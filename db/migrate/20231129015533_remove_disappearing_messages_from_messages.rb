class RemoveDisappearingMessagesFromMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :disappearing_messages, :interval
  end
end
