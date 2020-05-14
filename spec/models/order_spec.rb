require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:item) { create(:item) }

  it "1000円、1商品、税8%のとき2050円になること" do
    order = user.orders.build
    order.order_items.build(quantity: 1, item: Item.new(name: 'Apple', price: 1000))
    expect(order.subtotal).to eq(1000)
    expect(order.delivery_fee).to eq(300)
    expect(order.postage).to eq(600)
    expect(order.total_with_tax).to eq(2050)
  end

  it "4000円、6商品、税8%のとき5940円になること" do
    order = user.orders.build
    order.order_items.build(quantity: 2, item: Item.new(name: 'Apple', price: 200))
    order.order_items.build(quantity: 4, item: Item.new(name: 'Peach', price: 900))
    expect(order.subtotal).to eq(4000)
    expect(order.delivery_fee).to eq(300)
    expect(order.postage).to eq(1200)
    expect(order.total_with_tax).to eq(5940)
  end

  it "100,000円、1商品、税8%のとき109,730円になること" do
    order = user.orders.build
    order.order_items.build(quantity: 1, item: Item.new(name: '高級時計', price: 100_000))
    expect(order.subtotal).to eq(100_000)
    expect(order.delivery_fee).to eq(1000)
    expect(order.postage).to eq(600)
    expect(order.total_with_tax).to eq(109730)
  end

  it "注文にアイテムが関連づく" do
    order = user.orders.build
    order.order_items.build(quantity: 1, item: Item.new(name: '高級時計', price: 100_000))
    order.address     = user.address
    order.ship_time   = '8時から12時'
    order.ship_date   = Date.current.since(3.days)
    order.total_price = Date.current.since(3.days)
    # order.order_items.build(quantity: 2, item: item)
    order.save

    expect(order.total_price).to eq(109730)
    expect(order.address).to eq('東京都新宿区１２３４')
    expect(order.order_items.count).to eq(1)
    expect(OrderItem.first.item.name).to eq('高級時計')
  end
end

