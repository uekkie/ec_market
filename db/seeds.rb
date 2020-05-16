if User.count == 0
  User.create(email: 'yamada@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')
end

if User.where(admin: true).count == 0
  User.create(email: 'admin@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa', admin: true)
end

if Shop.count == 0
  Shop.create
end

if Item.count == 0
  shop = Shop.first
  shop.items.create(name: "りんご", price: 200, description: "おいしいりんご", position: 1)
  shop.items.create(name: "みかん", price: 400, description: "おいしいみかん", position: 2)
  shop.items.create(name: "もも", price: 500, description: "おいしいもも", position: 3)
end
