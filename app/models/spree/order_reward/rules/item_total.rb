# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class OrderReward
    module Rules
      class ItemTotal < OrderRewardRule
        preference :amount_min, :decimal, default: 100.00
        preference :operator_min, :string, default: '>'
        preference :amount_max, :decimal, default: 1000.00
        preference :operator_max, :string, default: '<'

        OPERATORS_MIN = ['gt', 'gte'].freeze
        OPERATORS_MAX = ['lt', 'lte'].freeze

        def eligible?(order, _options = {})
          eligibility_errors.add(:base, ineligible_message_min) unless eligible_min?(order)
          eligibility_errors.add(:base, ineligible_message_max) unless eligible_max?(order)
          eligibility_errors.empty?
        end

        private

        def eligible_max?(order)
          order.item_total.send(selected_operator_max, selected_amount(preffered_amount_max))
        end

        def eligible_min?(order)
          order.item_total.send(selected_operator_min, selected_amount(preffered_amount_min))
        end

        def formatted_amount(preffered_amount)
          Spree::Money.new(preffered_amount).to_s
        end

        def ineligible_message_max
          if preferred_operator_max == 'gte'
            eligibility_error_message(:item_total_more_than_or_equal, amount: formatted_amount(preffered_amount_max))
          else
            eligibility_error_message(:item_total_more_than, amount: formatted_amount(preffered_amount_max))
          end
        end

        def ineligible_message_min
          if preferred_operator_min == 'gte'
            eligibility_error_message(:item_total_less_than, amount: formatted_amount(preffered_amount_min))
          else
            eligibility_error_message(:item_total_less_than_or_equal, amount: formatted_amount(preffered_amount_min))
          end
        end

        def selected_amount(amount)
          BigDecimal.new(amount.to_s)
        end

        def selected_operator_max
          preferred_operator_max == 'lte' ? :<= : :<
        end

        def selected_operator_min
          preferred_operator_min == 'gte' ? :>= : :>
        end
      end
    end
  end
end
