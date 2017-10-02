module Spree
  class OrderReward < Spree::Base
    MATCH_POLICIES = %w(all any).freeze

    has_many :order_reward_rules, autosave: true, dependent: :destroy
    alias_method :rules, :order_reward_rules

    has_many :order_reward_actions, autosave: true, dependent: :destroy
    alias_method :actions, :order_reward_actions

    accepts_nested_attributes_for :order_reward_actions, :order_reward_rules
    validates :name, presence: true

    def any_action_applies?(order)
      actions.any? { |action| action.eligible?(order) }
    end

    def any_rule_applies?(order)
      return true if rules.empty?
      rules.any? { |rule| rule.eligible?(order) }
    end

    def eligible?(order)
      # check if order is eligible for the reward
      return false if expired?
      any_rule_applies?(order) && any_action_applies?(order)
    end

    def expired?
      !!(starts_at && Time.current < starts_at || expires_at && Time.current > expires_at)
    end

    def match_all?
      match_policy == 'all'
    end

    def reward(order)
      # reward order user with the reward
      actions.each do |action|
        if action.eligible?(order)
          action.perform(order)
        end
      end
    end

    def reward_result_description(order, action_delimiter = " ")
      return unless eligible?(order)
      action_description = actions.map do |action|
        action.customer_description(order)
      end.reject(&:blank?).join(action_delimiter)

      return if action_description.blank?
      "#{name}: #{action_description}"
    end

    def reward_result_amounts(order)
      amounts = {}
      return amounts unless eligible?(order)

      actions.each do |action|
        next unless action.eligible?(order)
        action_type = action.class.name.demodulize.titleize
        action_amount = action.calculate_amount(order)
        amounts[action_type] = amounts[action_type] ? amounts[action_type] + action_amount : action_amount
      end
      amounts
    end
  end
end
