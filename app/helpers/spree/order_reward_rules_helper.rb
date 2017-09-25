module Spree
  module OrderRewardRulesHelper
    def options_for_order_reward_rule_types(order_reward)
      options = order_reward_rule_build_options(order_reward)
      options_for_select options
    end

    def order_reward_rule_build_options(order_reward)
      existing = order_reward_rule_existing_rules(order_reward)
      rule_names = Rails.application.config.spree.order_rewards.rules.map(&:name).reject do |r|
        existing.include? r
      end
      rule_names.map do |name|
        [name.demodulize.titleize, name]
      end
    end

    def order_reward_rule_existing_rules(order_reward)
      order_reward.rules.map { |rule| rule.class.name }
    end
  end
end
