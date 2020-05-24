class Coupon < ApplicationRecord
  before_validation :generate_code

  scope :recent, -> { order(created_at: :desc) }

  def self.generate_code
    SecureRandom.hex(6).upcase
  end

  private

  def generate_code
    self.code = SecureRandom.hex(6).upcase
  end
end
