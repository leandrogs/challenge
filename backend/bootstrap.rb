class Payment
  attr_reader :authorization_number, :amount, :invoice, :order, :payment_method, :paid_at

  def initialize(attributes = {})
    @authorization_number, @amount = attributes.values_at(:authorization_number, :amount)
    @invoice, @order = attributes.values_at(:invoice, :order)
    @payment_method = attributes.values_at(:payment_method)
  end

  def pay(paid_at = Time.now)
    @amount = order.total_amount
    @authorization_number = Time.now.to_i
    @invoice = Invoice.new(billing_address: order.address, shipping_address: order.address, order: order)
    @paid_at = paid_at
    order.close(@paid_at)
  end

  def paid?
    !paid_at.nil?
  end
end

class Invoice
  attr_reader :billing_address, :shipping_address, :order

  def initialize(attributes = {})
    @billing_address = attributes.values_at(:billing_address)
    @shipping_address = attributes.values_at(:shipping_address)
    @order = attributes.values_at(:order)
  end
end

class Order
  attr_reader :customer, :items, :payment, :address, :closed_at

  def initialize(customer, overrides = {})
    @customer = customer
    @items = []
    @address = overrides.fetch(:address) { Address.new(zipcode: '45678-979') }
  end

  def add_item(item)
    @items << item
  end

  def total_amount
    @items.map(&:total).inject(:+)
  end

  def close(closed_at = Time.now)
    @closed_at = closed_at
  end

  def deliver
    @items.each do |item|
      item.deliver
    end
  end
end

class OrderItem
  attr_reader :order, :product

  def initialize(order:, product:)
    @order = order
    @product = product
    post_initialize
  end

  def shipping_warnings
    {}
  end

  def deliver
    raise NotImplementedError
  end

  def post_initialize
    nil
  end

  def total
    10
  end
end

class Physical < OrderItem
  def deliver
    ShippingLabel.new(product: product, address: order.address).generate
  end
end

class Book < OrderItem
  def shipping_warnings
    { warning: "Books are free of federal taxes. Constitution Art. 150, VI, d." }
  end

  def deliver
    ShippingLabel.new(product: product, address: order.address).generate
  end
end

class Digital < OrderItem
  NOTIFICATION_MESSAGE = "Your digital media is already available."
  BONUS_VALUE = 10

  def deliver
    Notification.new(customer: order.customer, message: NOTIFICATION_MESSAGE).notify
    order.customer.add_bonus(BONUS_VALUE)
  end
end

class Membership < OrderItem
  NOTIFICATION_MESSAGE = "Your membership is already available."

  def deliver
    activate
    order.customer.add_membership(product)
    Notification.new(customer: order.customer, message: NOTIFICATION_MESSAGE).notify
  end

  def post_initialize
    @active = false
  end

  private

  def activate
    @active = true
  end
end

class Product
  attr_reader :name, :type

  def initialize(name:)
    @name = args[:name]
    @type = args[:type]
  end
end

class ShippingLabel
  def initialize(product:, address:)
    @product = args[:product]
    @address = args[:address]
  end

  def generate
    {
      address: @address
    }.merge(product.shipping_warnings)
  end
end

class Notification
  def initialize(customer:, message:)
    @customer = args[:customer]
    @message = args[:message]
  end

  def notify
    p "To: #{@customer.email} - Message: #{@message}"
  end
end

class Address
  attr_reader :zipcode

  def initialize(zipcode:)
    @zipcode = zipcode
  end
end

class CreditCard
  def self.fetch_by_hashed(code)
    CreditCard.new
  end
end

class Customer
  def initialize(email:)
    @email = args[:email]
    @memberships = []
    @bonus = 0
  end

  def add_membership(membership)
    @memberships << membership
  end

  def add_bonus(bonus_value)
    @bonus += bonus_value
  end
end

foolano = Customer.new(email: 'a@a.com')

book = Product.new(name: 'Awesome book', type: :book)
tv = Product.new(name: 'Awesome tv', type: :physical)
music = Product.new(name: 'Awesome music', type: :digital)
netflix = Product.new(name: 'Awesome netflix', type: :membership)

order = Order.new(foolano)
order.add_product(Book.new(order, book))
order.add_product(Physical.new(order, tv))
order.add_product(Digital.new(order, music))
order.add_product(Membership.new(order, netflix))

payment = Payment.new(order: order, payment_method: CreditCard.fetch_by_hashed('43567890-987654367'))
payment.pay
if payment.paid?
  payment.order.deliver
end
