class Cart < ApplicationRecord
  has_many :cart_items

  def subtotal
    cart_items.sum(&:subtotal)
  end
end
