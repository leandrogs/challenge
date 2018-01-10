require_relative 'item'
require_relative '../lib/notification'

module ProductOrder
  class Membership < Item
    attr_reader :active

    NOTIFICATION_MESSAGE = "Your membership is already available."

    def deliver(order)
      activate
      order.customer.add_membership(self)
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
end
