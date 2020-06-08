class AddUserPointToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :user_point, :integer, null: false, default: 0
  end
end
