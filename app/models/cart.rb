class Cart < ApplicationRecord
  has_many :cart_items

  def empty?
    cart_items.blank?
  end

  def subtotal
    cart_items.sum(&:subtotal)
  end
end
