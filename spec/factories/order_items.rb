FactoryBot.define do
  factory :order_item do
    item
    order
    quantity { 2 }
  end
end
