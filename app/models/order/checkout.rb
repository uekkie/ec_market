class Order::Checkout
  def self.create!(user:, order:, customer:)
    new(user: user, order: order, customer: customer).create!
  end

  def initialize(user:, order:, customer:)
    @user = user
    @order = order
    @customer = customer
  end

  def create!
    Order.transaction(joinable: false, requires_new: true) do
      order.save!
      checkout!
    end
    true
  end

  private

  def checkout!
    raise 'Stripeでの決済に失敗しました。カード情報を確認してください。' unless customer

    user.charge(customer,
                order.total_with_tax)
    user.update!(stripe_customer_id: customer.id)
  end

  attr_reader :order, :user, :customer
end
