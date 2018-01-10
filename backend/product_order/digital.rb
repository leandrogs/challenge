require_relative 'item'
require_relative '../lib/notification'

module ProductOrder
  class Digital < Item
    NOTIFICATION_MESSAGE = "Your digital media is already available."
    BONUS_VALUE = 10

    def deliver(order)
      Notification.new(customer: order.customer, message: NOTIFICATION_MESSAGE).notify
      order.customer.add_bonus(BONUS_VALUE)
    end
  end
end
