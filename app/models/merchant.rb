class Merchant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  scope :recent, -> { order(created_at: :desc) }

  has_many :items, dependent: :destroy
  has_many :orders

  def own_order(order)
    raise unless self == order.merchant
  end

  def prepare_shipping(order)
    own_order(order)
    order.prepare_shipping!
  end

  def shipped(order)
    own_order(order)
    order.shipped!
  end

  def cancel(order)
    own_order(order)
    order.canceled!
  end
end
