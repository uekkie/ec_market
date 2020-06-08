class Item < ApplicationRecord
  validates :name, :price, presence: true

  acts_as_list
  mount_uploader :image, ImageUploader
  scope :listed, -> { order(position: :asc) }
  scope :displayed, -> { where(hidden: false) }
end
