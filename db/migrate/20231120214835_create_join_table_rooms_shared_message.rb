class CreateJoinTableRoomsSharedMessage < ActiveRecord::Migration[7.0]
  def change
    create_join_table :rooms, :shared_messages do |t|
      t.index %i[room_id shared_message_id]
      t.index %i[shared_message_id room_id]
    end
  end
end
