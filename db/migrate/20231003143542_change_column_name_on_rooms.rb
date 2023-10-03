class ChangeColumnNameOnRooms < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :type, :integer
    add_column :rooms, :room_type, :integer, default: 0
  end
end
