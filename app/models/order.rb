class Order < ApplicationRecord
  before_validation do
    if self.user_point > self.user.point
      self.errors.add(:user_point, '上限を超えています')
    end

    self.total_price = total_with_tax - user_point
  end

  belongs_to :user
  belongs_to :merchant
  has_many :order_items

  validates :address, :ship_time, :ship_date, presence: true

  # 注文済み
  # 発送処理中
  # 処理中発送済み
  # キャンセル
  enum status: { ordered: 0, prepare_shipping: 1, shipped: 2, canceled: 3 }

  scope :recent, -> { order(created_at: :desc) }

  POSTAGE_FEE = 600

  def build_order_items(cart, merchant_id)
    cart.filtered_merchant_id(merchant_id.to_i).each do |cart_item|
      order_items.build(item: cart_item.item, quantity: cart_item.quantity)
      if self.merchant.nil?
        self.merchant = cart_item.item.merchant
      end
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
    ((amount / merchant.quantity_per_box) + 1) * POSTAGE_FEE
  end

  def total
    total = subtotal + delivery_fee + postage
  end

  def total_with_tax
    (total + tax_fee).round(-1)
  end

end
