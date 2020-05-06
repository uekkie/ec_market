class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false, default: ""
      t.string :image, default: ""
      t.integer :price, null: false, default: 0
      t.text :description, default: ""
      t.boolean :hidden, null: false, default: false
      t.integer :order, null: false, default: 0

      t.timestamps
    end
  end
end
