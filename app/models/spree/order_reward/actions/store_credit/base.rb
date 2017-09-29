module Spree
  class OrderReward
    module Actions
      class StoreCredit
        module Base
          def display_calculate_amount(order)
            amount = calculate_amount(order)
            Spree::Money.new(amount, currency: order.currency).to_html
          end

          def eligible?(order)
            order.user.present?
          end

          def perform(order, options = {})
            return unless eligible?(order)

            begin
              store_credit = prepare(order, options)
              store_credit.created_by = options[:created_by] || Spree::User.admin.first
              store_credit.save!
            rescue StandardError => error
              Rails.logger.error "#{self.class.name} order ##{order.number}, #{order_reward.id}: #{error.message}"
            end
          end

          def prepare(order, options = {})
            return unless eligible?(order)

            amount = calculate_amount(order)
            prepare_store_credit(order, amount, options)
          end

          def customer_description(order)
            "Your account will be credited with Store Credit amount of #{display_calculate_amount(order)}."
          end

          private

          def prepare_store_credit(order, amount, options)
            category = options[:category] || Spree::StoreCreditCategory.first
            Spree::StoreCredit.new(
              user: order.user,
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
end
