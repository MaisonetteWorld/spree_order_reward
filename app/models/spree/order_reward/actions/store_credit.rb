module Spree
  class OrderReward
    module Actions
      class StoreCredit < OrderRewardAction
        preference :amount, :decimal, default: 0
        preference :for_every, :decimal, default: 0

        def calculate_amount(order)
          if preferred_for_every > 0
            preferred_amount * (order.item_total / preferred_for_every).floor
          else
            preferred_amount
          end
        end

        def perform(options = {})
          store_credit = prepare(options)
          store_credit.created_by = options[:created_by] || Spree::User.admin.first
          store_credit.save!
        end

        def prepare(options = {})
          order = options[:order]
          return unless order_eligable?(order)

          amount = calculate_amount(order)
          prepare_store_credit(options, amount)
        end

        def customer_description(order)
          "Your account will be credited with Store Credit amount of #{calculate_amount(order)}."
        end

        private

        def prepare_store_credit(options, order, amount)
          category = options[:category] || Spree::StoreCreditCategory.first
          Spree::StoreCredit.new(
            user: order.user,
            amount: amount,
            category: category,
            created_by: Spree::StoreCredit.default_created_by,
            memo: "Reward for order #{@order.number}",
            currency: order.currency
          )
        end

        def order_eligable?(order)
          order.user.present?
        end
      end
    end
  end
end
