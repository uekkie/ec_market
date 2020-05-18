class Order < ApplicationRecord
  before_validation do
    self.total_price = total_with_tax
  end

  belongs_to :user
  validates :address, :ship_time, :ship_date, presence: true

  has_many :order_items

  scope :recent, -> { order(created_at: :desc) }

  POSTAGE_FEE = 600

  def build_order_items(cart)
    cart.cart_items.each do |cart_item|
      order_items.build(item: cart_item.item, quantity: cart_item.quantity)
    end
  end

  def self.business_days
    (3..14).map { |i| [i.business_day.from_now, I18n.l(i.business_day.from_now, format: :short)] }
  end

  def subtotal
    order_items.sum(&:subtotal)
  end

  def amount
    order_items.sum(&:quantity)
  end

  def tax_fee
    (BigDecimal(total.to_s) * BigDecimal("0.08")).ceil
  end

  def delivery_fee

    case subtotal
    when 0...10000
      300
    when 10_000...30_000
      400
    when 30_000...100_000
      600
    else
      1000
    end
  end

  def postage
    ((amount / 5) + 1) * POSTAGE_FEE
  end

  def total
    total = subtotal + delivery_fee + postage
  end

  def total_with_tax
    (total + tax_fee).round(-1)
  end

end
