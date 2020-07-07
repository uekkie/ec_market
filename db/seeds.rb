if User.count == 0
  User.create(nick_name: 'やまだ', email: 'yamada@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')
end

if User.where(admin: true).count == 0
  User.create(nick_name: 'アドミン', email: 'admin@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa', admin: true)
end

if Merchant.count == 0
  merchant = Merchant.create(name: 'マルオ青果店', email: 'maruo@example.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')
end

if Item.count == 0
  merchant.items.create(name: "りんご", price: 200, description: "おいしいりんご", position: 1)
  merchant.items.create(name: "みかん", price: 400, description: "おいしいみかん", position: 2)
  merchant.items.create(name: "もも", price: 500, description: "おいしいもも", position: 3)
end
