class AddLastLoggedInAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_logged_in_at, :datetime
    add_column :users, :last_logged_out_at, :datetime
  end
end
