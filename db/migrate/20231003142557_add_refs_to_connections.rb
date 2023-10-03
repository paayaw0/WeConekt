class AddRefsToConnections < ActiveRecord::Migration[7.0]
  def change
    add_reference :connections, :room, foreign_key: true
    add_reference :connections, :message, foreign_key: true
  end
end
