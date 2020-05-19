class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  scope :recent, -> { order(created_at: :desc) }
  validates :title, :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :goods, dependent: :destroy

  def good_user(user_id)
    goods.find_by(user_id: user_id)
  end
end
