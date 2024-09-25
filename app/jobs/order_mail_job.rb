class OrderMailJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    # Do something later
    order = Order.find(order_id)
    puts "Sending mail to the users!"
    OrderMailer.order_confirmation(order).deliver_now
  end
end
