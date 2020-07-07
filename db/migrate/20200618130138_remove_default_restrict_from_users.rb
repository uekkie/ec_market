class RemoveDefaultRestrictFromUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :email, from: '', to: nil
    change_column_default :users, :nick_name, from: '', to: nil
  end
end
