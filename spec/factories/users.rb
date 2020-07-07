FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    nick_name { 'ユーザー' }
    password { 'password' }
    password_confirmation { 'password' }
    after(:create) do |user|
      user.shipping_address = create(:shipping_address, user: user)
    end
  end

  factory :admin, class: User do
    sequence(:email) { |_n| 'admin@example.com' }
    nick_name { 'アドミン' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end
end
