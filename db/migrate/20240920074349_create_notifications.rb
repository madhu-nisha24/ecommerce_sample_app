class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.string :email
      t.integer :product_id

      t.timestamps
    end
  end
end
