# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class OrderReward
    module Rules
      class ReferredTransaction < OrderRewardRule

        def eligible?(order, options = {})
          if !completed_orders(order).blank? && completed_orders(order).first != order
            eligibility_errors.add(:base, eligibility_error_message(:not_first_order))
          end
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

        def completed_orders(order)
          order.user ? order.user.orders.complete : orders_by_email
        end

        def orders_by_email
          Spree::Order.where(email: email).complete
        end

      end
    end
  end
end
