module Spree
  class OrderReward
    module Actions
      class PromoCodeTier < OrderRewardAction
        include PromoCode::Base

        preference :amount, :decimal, default: 0
        preference :from, :decimal, default: nil
        preference :to, :decimal, default: nil

        def calculate_amount(_order)
          preferred_amount
        end

        def eligible?(order)
          order.user.present? &&
            (preferred_from.blank? || preferred_from <= order.item_total) &&
            (preferred_to.blank? || preferred_to > order.item_total)
        end
      end
    end
  end
end
