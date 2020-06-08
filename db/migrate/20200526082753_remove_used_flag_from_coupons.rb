class RemoveUsedFlagFromCoupons < ActiveRecord::Migration[6.0]
  def up
    remove_column :coupons, :used
  end

  def down
    add_column :coupons, :used, :boolean, null: false, default: false
  end
end
