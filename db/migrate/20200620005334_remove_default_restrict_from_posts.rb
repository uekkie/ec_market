class RemoveDefaultRestrictFromPosts < ActiveRecord::Migration[6.0]
  def change
    change_column_default :posts, :title, from: "", to: nil
    change_column_default :posts, :content, from: "", to: nil
  end
end
