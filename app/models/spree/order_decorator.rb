module Spree
  Order.class_eval do
    state_machine do
      after_transition to: :complete, do: :apply_order_rewards
    end

    def apply_order_rewards
      eligible_order_rewards.each do |order_reward|
        order_reward.reward(self)
      end
    end

    def eligible_order_rewards
      OrderReward.select do |order_reward|
        order_reward.eligible?(self)
      end
    end

    def order_rewards_description(delimiter = "\n", action_delimiter = " ")
      eligible_order_rewards.map do |order_reward|
        order_reward.reward_result_description(self, action_delimiter)
      end.reject(&:blank?).join(delimiter)
    end

    def order_rewards_amounts
      order_amounts = {}
      eligible_order_rewards.each do |order_reward|
        order_reward_amounts = order_reward.reward_result_amounts(self)
        order_reward_amounts.each do |key, value|
          order_amounts[key] = 0 if order_amounts[key].blank?
          order_amounts[key] += value
        end
      end
      order_amounts
    end
  end
end
