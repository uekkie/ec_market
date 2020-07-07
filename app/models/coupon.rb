class Coupon < ApplicationRecord
  before_validation :generate_code
  belongs_to :user, optional: true

  scope :recent, -> { order(created_at: :desc) }

  def self.generate_code
    SecureRandom.hex(6).upcase
  end

  def display_code
    code.scan(/.{1,4}/).join('-')
  end

  def display_used
    used? ? '使用済み' : '未使用'
  end

  def used?
    user.present?
  end

  private

  def generate_code
    self.code = SecureRandom.hex(6).upcase
  end
end
