class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  scope :recent, -> { order(created_at: :desc) }
  validates :title, :content, presence: true
end
