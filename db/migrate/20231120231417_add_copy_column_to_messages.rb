class AddCopyColumnToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :copy, :boolean, default: false
  end
end
