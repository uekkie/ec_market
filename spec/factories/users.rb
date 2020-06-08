FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    address { '東京都新宿区１２３４' }
  end

  factory :admin, class: User do
    sequence(:email) { |n| "admin@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    address { '東京都新宿区１２３４' }
    admin { true }
  end
end
