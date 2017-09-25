module Spree
  Order.class_eval do
    state_machine do
      after_transition to: :complete, do: :apply_order_rewards
    end

    def apply_order_rewards
      eligible_order_rewards.each do |order_reward|
        order_reward.reward(order)
      end
    end

    def eligible_order_rewards
      OrderReward.active.select do |order_reward|
        order_reward.order_eligible?(self)
      end
    end

    def order_rewards_description(delimiter = "\n", action_delimiter = " ")
      eligible_order_rewards.each do |order_reward|
        order_reward.reward_description(order, action_delimiter)
      end.map(delimiter)
    end
  end
end
