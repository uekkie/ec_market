class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, default: ""
      t.text :content, null: false, default: ""
      t.string :image

      t.timestamps
    end
  end
end
