class AddMerchantRefToItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :merchant, null: true, foreign_key: true
  end
end
