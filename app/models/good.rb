class Good < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  validates :user_id, presence: true, uniqueness: { scope: :post_id }
  validates :post_id, presence: true
end
