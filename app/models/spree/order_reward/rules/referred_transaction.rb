# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class OrderReward
    module Rules
      class ReferredTransaction < OrderRewardRule


        def eligible?(order, _options = {})
          eligibility_errors.add(:base, ineligible_message_ref) unless eligible_referred?(order)
          eligibility_errors.empty?
        end

        private

        def ineligible_message_ref
          eligibility_error_message(:order_not_referred)
        end

        def eligible_referred?(order)
          order.user.referred?
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
