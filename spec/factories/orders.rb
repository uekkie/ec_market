FactoryBot.define do
  factory :order do
    user
    merchant
    address { '東京都千代田区1丁目' }
    ship_time { '14時〜16時' }
    ship_date { 3.days.since }
    total_price { 1000 }
  end
end
