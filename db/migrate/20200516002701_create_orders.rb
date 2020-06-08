class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address, null: false
      t.string :ship_time, null: false
      t.date :ship_date, null: false
      t.integer :total_price, null: false
      t.integer :tax, null: false, default: 8

      t.timestamps
    end
  end
end
