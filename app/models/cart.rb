class Cart < ApplicationRecord
  has_many :cart_items

  def total_price
    cart_items.sum(&:subtotal)
  end
end
