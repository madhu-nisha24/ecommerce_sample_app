class OrderMailer < ApplicationMailer
  default from: 'no-reply@yourapp.com'

  def order_confirmation(order)
    @order = order
    mail(to: 'nishacbe29@gmail.com', subject: 'Order Confirmation')
  end
end
