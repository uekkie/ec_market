FactoryBot.define do
  factory :comment do
    user { nil }
    post { nil }
    body { "" }
  end
end
