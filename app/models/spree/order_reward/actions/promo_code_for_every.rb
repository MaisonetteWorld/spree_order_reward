module Spree
  class OrderReward
    module Actions
      class PromoCodeForEvery < OrderRewardAction
        include PromoCode::Base

        preference :amount, :decimal, default: 0
        preference :for_every, :decimal, default: nil

        def calculate_amount(order)
          preferred_amount * (order.item_total / preferred_for_every).floor
        end

        def eligible?(order)
          order.user.present? && preferred_for_every >= order.item_total
        end
      end
    end
  end
end
