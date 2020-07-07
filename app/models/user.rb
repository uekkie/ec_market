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
end
