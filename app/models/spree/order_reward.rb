module Spree
  class OrderReward < Spree::Base
    MATCH_POLICIES = %w(all any).freeze

    has_many :order_reward_rules, autosave: true, dependent: :destroy
    alias_method :rules, :order_reward_rules

    has_many :order_reward_actions, autosave: true, dependent: :destroy
    alias_method :actions, :order_reward_actions

    accepts_nested_attributes_for :order_reward_actions, :order_reward_rules
    validates :name, presence: true

    def any_rule_applies?(order)
      rules.any? { |rule| rule_applies?(order, rule) }
    end

    def eligible?(order)
      # check if order is eligible for the reward
      return false if expired?
      any_rule_applies?(order)
    end

    def expired?
      !!(starts_at && Time.current < starts_at || expires_at && Time.current > expires_at)
    end

    def match_all?
      match_policy == 'all'
    end

    def reward(order)
      # reward order user with the reward
      binding.pry
      actions.each do |action|
        action.perform(order: order)
      end
    end

    def reward_description(order, action_delimiter = " ")
      return unless eligible?(order)
      action_description = actions.map do |action|
        action.customer_description(order)
      end.join(action_delimiter)
      "#{name}: #{action_description}"
    end

    def rule_applies?(order, rule)
      rule.eligible?(order)
    end
  end
end
