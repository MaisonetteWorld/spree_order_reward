module Spree
  class OrderReward
    module Actions
      class StoreCredit < OrderRewardAction
        include StoreCredit::Base

        preference :amount, :decimal, default: 0

        def calculate_amount(_order)
          preferred_amount
        end
      end
    end
  end
end
