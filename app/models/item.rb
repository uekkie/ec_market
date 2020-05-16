class Item < ApplicationRecord
  validates :name, :price, presence: true

  belongs_to :shop
  acts_as_list scope: :shop
end
