class AddSeenAtToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :seen_at, :datetime, default: nil
  end
end
