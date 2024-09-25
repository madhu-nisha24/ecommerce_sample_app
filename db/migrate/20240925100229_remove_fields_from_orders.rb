class RemoveFieldsFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :status, :string
  end
end
