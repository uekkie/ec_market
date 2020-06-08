class Item < ApplicationRecord
  validates :name, :price, presence: true

  belongs_to :merchant, optional: true

  acts_as_list
  mount_uploader :image, ImageUploader
  scope :listed, -> { order(position: :asc) }
  scope :displayed, -> { where(hidden: false) }
  scope :recent, -> { order(created_at: :desc) }
end
