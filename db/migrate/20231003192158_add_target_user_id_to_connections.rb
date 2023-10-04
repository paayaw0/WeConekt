class AddTargetUserIdToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :target_user_id, :integer
  end
end
