class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false, default: ""
      t.string :image, null: false, default: ""
      t.integer :price, null: false
      t.text :description, null: false, default: ""
      t.boolean :hidden, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
