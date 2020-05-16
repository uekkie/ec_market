FactoryBot.define do
  factory :order do
    user { nil }
    address { "MyString" }
    ship_time { "MyString" }
    ship_date { "2020-05-16" }
    total_price { 1 }
    tax { 1 }
  end
end
