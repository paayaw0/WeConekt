class RemoveMessageRefFromConnections < ActiveRecord::Migration[7.0]
  def change
    remove_reference :connections, :message, foreign_key: true
  end
end
