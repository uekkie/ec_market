FactoryBot.define do
  factory :coupon do
    point { 500 }
    code { Coupon.generate_code }
  end
end
