FactoryBot.define do
  factory :order_item do
    item { create(:item) }
    quantity { 2 }
  end
end
