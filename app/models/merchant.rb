class Merchant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  scope :recent, -> { order(created_at: :desc) }

  has_many :items, dependent: :destroy
  has_many :orders

  def prepare_shipping(order)
    raise unless self == order.merchant
    order.prepare_shipping!
  end

  def shipped(order)
    raise unless self == order.merchant
    order.shipped!
  end

  def cancel(order)
    raise unless self == order.merchant
    order.canceled!
  end
end
