module Spree
  class OrderRewardMailer < Spree::BaseMailer
    def promo_code_email(order, order_reward, display_amount, code)
      @order_reward = order_reward
      @display_amount = display_amount
      @order = order
      @code = code
      subject = "Reward for order #{order.number}"
      mail(to: order.email, from: from_address, subject: subject)
    end
  end
end
