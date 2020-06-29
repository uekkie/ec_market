class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader
  has_many :orders, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :goods, dependent: :destroy

  has_many :coupons, dependent: :destroy

  has_one :shipping_address, dependent: :destroy, class_name: 'ShippingAddress'

  scope :normal, -> { where(admin: false) }
  scope :recent, -> { order(created_at: :desc) }

  def display_name
    nick_name.present? ? nick_name : email
  end

  def charge_coupon(coupon)
    return '使用済みのコードです' if coupon.used?
    ActiveRecord::Base.transaction do
      self.point += coupon.point
      save!
      coupon.update!(user: self)
    end
  end

  def use_point(order)
    self.point -= order.user_point
    save!
  end

  def has_customer_id?
    stripe_customer_id.present?
  end

  def customer
    return Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id.present?
  end

  def attach_customer(stripe_token)
    customer = Stripe::Customer.create(
      email: email,
      source: stripe_token
    )
    self.update_attribute(:stripe_customer_id, customer.id)
    customer
  rescue Stripe::CardError => e
    self.errors.add(:base, e.message)
    logger.error(e.message)
    nil
  end

  def charge(customer, price)
    return false unless customer.present?

    Stripe::Charge.create(
      :customer => customer.id,
      :amount => price,
      :description => "商品代金",
      :currency => "jpy"
    )
    true
  rescue Stripe::CardError => e
    self.errors.add(:base, e.message)
    logger.error(e.message)
    false
  end
end
