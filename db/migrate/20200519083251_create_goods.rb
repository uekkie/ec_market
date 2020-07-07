class CreateGoods < ActiveRecord::Migration[6.0]
  def change
    create_table :goods do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :goods, [:user_id, :post_id], unique: true
  end
end
