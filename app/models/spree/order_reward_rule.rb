module Spree
  class OrderRewardRule < Spree::Base
    belongs_to :order_reward, class_name: 'Spree::OrderReward', inverse_of: :order_reward_rules
    scope :of_type, ->(t) { where(type: t) }
    validate :unique_per_order_reward, on: :create

    def eligible?(_order, _options = {})
      raise 'eligible? should be implemented in a sub-class of Spree::OrderRewardRule'
    end

    def eligibility_errors
      @eligibility_errors ||= ActiveModel::Errors.new(self)
    end

    private

    def unique_per_order_reward
      if Spree::OrderRewardRule.exists?(order_reward_id: order_reward_id, type: self.class.name)
        errors[:base] << "OrderReward already contains this rule type"
      end
    end

    def eligibility_error_message(key, options = {})
      Spree.t(key, Hash[scope: %i[eligibility_errors messages]].merge(options))
    end
  end
end
