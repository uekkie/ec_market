class Item < ApplicationRecord
  validates :name, :price, presence: true
end
