class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader
  has_many :orders
  has_many :posts, dependent: :destroy
  has_many :goods, dependent: :destroy

  has_many :coupons, dependent: :destroy

  scope :normal, -> { where(admin: false) }
  scope :recent, -> { order(created_at: :desc) }

  def display_name
    name.present? ? name : email
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
        email:  email,
        source: stripe_token
    )
    self.update_attribute(:stripe_customer_id, customer.id)
    customer
  end

  # def update_stripe_token(stripe_token)
  #   return false if self.customer.blank?
  #
  #   Stripe::Customer.update(self.customer.id, source: stripe_token)
  #   true
  # end

  def charge(customer, price)
    Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => price,
        :description => "商品代金",
        :currency    => "jpy"
    )
    true
  rescue Stripe::CardError => e
    flash[:error] = e.message
    false
  end
end
