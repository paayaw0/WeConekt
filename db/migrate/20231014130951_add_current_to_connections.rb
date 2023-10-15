class AddCurrentToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :current, :boolean, default: false
    add_column :connections, :last_connected_at, :datetime
  end
end
