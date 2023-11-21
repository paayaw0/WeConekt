class CreateSharedMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_messages do |t|
      t.references :message, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
