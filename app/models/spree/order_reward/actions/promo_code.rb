module Spree
  class OrderReward
    module Actions
      class PromoCode < OrderRewardAction
        include PromoCode::Base

        preference :amount, :decimal, default: 0

        def calculate_amount(_order)
          preferred_amount
        end
      end
    end
  end
end
