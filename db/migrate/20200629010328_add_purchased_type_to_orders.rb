class AddPurchasedTypeToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :purchased_type, :integer, null: false, default: 0
  end
end
