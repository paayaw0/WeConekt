class AddOnlineStatusAndLastSeentAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :online, :boolean, default: false
    add_column :users, :last_seen_at, :datetime
  end
end
