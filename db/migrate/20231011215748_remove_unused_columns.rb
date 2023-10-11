class RemoveUnusedColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :messages, :connection_id, :integer
    remove_column :connections, :target_user_id, :integer
  end
end
