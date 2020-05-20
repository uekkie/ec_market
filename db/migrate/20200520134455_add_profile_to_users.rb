class AddProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :nick_name, :string, null: false, default: ""
    add_column :users, :avatar, :string
  end
end
