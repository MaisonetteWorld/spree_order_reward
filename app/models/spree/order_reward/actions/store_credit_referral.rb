module Spree
  class OrderReward
    module Actions
      class StoreCreditReferral < OrderRewardAction
        include StoreCredit::Base

        preference :amount, :decimal, default: 0

        def calculate_amount(_order)
          preferred_amount
        end

        def eligible?(order)
          order.user.present?
        end

        def prepare_store_credit(order, amount, options)
          category = options[:category] || Spree::StoreCreditCategory.first
          Spree::StoreCredit.new(
            user: order.user.referred_by,
            amount: amount,
            category: category,
            created_by: Spree::StoreCredit.default_created_by,
            memo: "Reward for order #{order.number}",
            currency: order.currency
          )
        end
      end
    end
  end
end
