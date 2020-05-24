class AddPointToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :point, :integer, null: false, default: 0
  end
end
