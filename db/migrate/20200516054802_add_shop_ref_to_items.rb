class AddShopRefToItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :shop, null: false, foreign_key: true
  end
end
