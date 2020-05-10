FactoryBot.define do
  factory :cart_item do
    user { nil }
    item { nil }
    quantity { 1 }
  end
end
