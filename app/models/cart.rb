class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def empty?
    cart_items.blank?
  end

  def subtotal
    cart_items.sum(&:subtotal)
  end

  def cart_items_merchants
    cart_items.group_by { |cart_item| cart_item.item.merchant }
  end

  def filtered_merchant_id(merchant_id)
    cart_items.filter { |cart_item| cart_item.item.merchant.id == merchant_id }
  end
end
