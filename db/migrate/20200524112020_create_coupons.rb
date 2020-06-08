class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.integer :point, null: false, default: 0
      t.string :code, null: false
      t.boolean :used, null: false, default: false

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
