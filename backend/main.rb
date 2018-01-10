require_relative 'customer'
require_relative 'product'
require_relative 'order'
require_relative 'product_order/book'
require_relative 'product_order/physical'
require_relative 'product_order/digital'
require_relative 'product_order/membership'
require_relative 'credit_card'
require_relative 'payment'

foolano = Customer.new(email: 'a@a.com')

book = Product.new(name: 'Awesome book', type: :book)
tv = Product.new(name: 'Awesome tv', type: :physical)
music = Product.new(name: 'Awesome music', type: :digital)
netflix = Product.new(name: 'Awesome netflix', type: :membership)

order = Order.new(foolano)
order.add_item(ProductOrder::Book.new(product: book))
order.add_item(ProductOrder::Physical.new(product: tv))
order.add_item(ProductOrder::Digital.new(product: music))
order.add_item(ProductOrder::Membership.new(product: netflix))

credit_card = CreditCard.fetch_by_hashed('43567890-987654367')
payment = Payment.new(order: order, payment_method: credit_card)
payment.pay

if payment.paid?
  payment.order.deliver
end

p "Customer bonus: $#{foolano.bonus}"
p "Customer memberships: #{foolano.memberships.map(&:product).map(&:name)}"
