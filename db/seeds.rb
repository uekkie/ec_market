if User.count == 0
  User.create(email: 'yamada@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')
end

if Item.count == 0
  Item.create(name: "りんご", price: 200, description: "おいしいりんご", position: 1)
  Item.create(name: "みかん", price: 400, description: "おいしいみかん", position: 2)
  Item.create(name: "もも", price: 500, description: "おいしいもも", position: 3)
end
