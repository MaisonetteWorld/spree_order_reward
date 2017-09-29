module Spree
  class OrderReward
    module Actions
      class PromoCode
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
            amount = calculate_amount(order)
            display_amount = display_calculate_amount(order)

            begin
              promotion = generate_promotion(order, amount, options)
              send_email(order, display_amount, promotion.code)
            rescue StandardError => error
              Rails.logger.error "#{self.class.name} order ##{order.number}, #{order_reward.id}: #{error.message}"
            end
          end

          def prepare(_order, _options) end

          def send_email(order, display_amount, code)
            Spree::OrderRewardMailer.promo_code_email(order, order_reward, display_amount, code).deliver_later
          end

          def customer_description(order)
            "You will receive a promo code for the amount of #{display_calculate_amount(order)}."
          end

          private

          def generate_promotion(order, amount, _options)
            generator = Spree::PromoGenerator.new(
              :user_code_flat,
              amount: amount,
              user: order.user,
              label: "Reward for order #{order.number}",
              valid_from: order_reward.reward_valid_from,
              valid_to: order_reward.reward_valid_to
            )
            generator.promotion
          end
        end
      end
    end
  end
end
