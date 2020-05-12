class Order < ApplicationRecord
  before_validation do
    self.total_price = total_with_tax
  end

  has_many :order_items

  def self.business_days
    (3..14).map { |i| I18n.l(i.business_day.from_now, format: :short_jp) }
  end

  def subtotal
    order_items.sum(&:subtotal)
  end

  def amount
    order_items.sum(&:quantity)
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
    ((amount / 5) + 1) * 600
  end

  def total
    total = subtotal + delivery_fee + postage
  end

  def total_with_tax
    (total + (total * 8 / 100)).round(-1)
  end

end
