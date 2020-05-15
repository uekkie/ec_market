FactoryBot.define do
  factory :item do
    name { "MyString" }
    image { "MyString" }
    price { 1 }
    description { "MyText" }
    hidden { false }
    position { 1 }
  end
end
