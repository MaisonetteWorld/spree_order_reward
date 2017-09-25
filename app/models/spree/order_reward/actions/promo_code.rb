module Spree
  class OrderReward
    module Actions
      class PromoCode < OrderRewardAction
        preference :amount, :decimal, default: 0
        preference :for_every, :decimal, default: 0

        def customer_description(order)
          ''
        end
      end
    end
  end
end
