class AddCopyToAndCopyFromAttributesToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :copied_to, :integer
    add_column :messages, :copied_from, :integer
  end
end
