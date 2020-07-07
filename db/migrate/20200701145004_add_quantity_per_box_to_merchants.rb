class AddQuantityPerBoxToMerchants < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :quantity_per_box, :integer, null: false, default: 5
  end
end
