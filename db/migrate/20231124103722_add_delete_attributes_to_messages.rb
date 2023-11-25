class AddDeleteAttributesToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :delete_for_current_user_id, :integer
    add_column :messages, :delete_for_everyone, :boolean, default: false
  end
end
