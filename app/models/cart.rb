class Cart < ApplicationRecord
  has_many :cart_items

  def empty?
    cart_items.blank?
  end

  def subtotal
    cart_items.sum(&:subtotal)
  end

  def cart_items_group_by_merchant(merchant_id)
    cart_items.filter { |cart_item| cart_item.item.merchant.id == merchant_id }
  end
end
