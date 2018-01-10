# Backend test explanation

**Author:** Leandro Gomes da Silva - [leandrogs99@gmail.com](leandrogs99@gmail.com)

This is my solution to Creditas backend challenge. I solved it in the past but
my proposal was not accepted by the crew. They sent me a nice feedback about
what I needed to improve and here is the result.

## Solution

I noticed that this problem deals with 4 different kind of products, each with
its own way deliver way. I started to think the best way to store each product
in the database. The simplest and easier way is to store everything inside a
*Product* table with a column named *type* to group the products for its
particularities.

I improved the *OrderItem* class to act as a base model for each type of
product. Then, for each type, I created one class to implement each
particularity related to the delivery process. This way, it becomes easier to
add a new type o product with a complete different delivery process.

To be able to make an order, the system needs to identify the type of the
product to create an *Order* with the right *order_item_class*. Leaving the code
exactly like this, each *Order* can store only one type of prodcut. To improve
this, I extracted the *order_item_class* from the inside out so *Order* does not
know what it is carrying.

Now, with all this code change, the system needs to identify the product type
only before it adds products to an *Order*. It leaves the system flexible to be
user-friendly when dealing with the shopping cart and payments.

```ruby
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
```
