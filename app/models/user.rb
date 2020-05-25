class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader
  has_many :orders
  has_many :posts, dependent: :destroy
  has_many :goods, dependent: :destroy

  scope :normal, -> { where(admin: false) }
  scope :recent, -> { order(created_at: :desc) }

  def display_name
    name.present? ? name : email
  end

  def charge_coupon(coupon)
    raise '使用済みのコードです' if self.used
    self.point += coupon.point
    self.used  = true
    save
  end
end
