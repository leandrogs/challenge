class Notification
  def initialize(customer:, message:)
    @customer = customer
    @message = message
  end

  def notify
    p "To: #{@customer.email} - Message: #{@message}"
  end
end
