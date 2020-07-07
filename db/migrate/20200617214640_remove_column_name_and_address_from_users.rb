class RemoveColumnNameAndAddressFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :name
    remove_column :users, :address
  end

  def down
    add_column :users, :name, :string, default: '', null: false
    add_column :users, :address, :string, default: '', null: false
  end
end
