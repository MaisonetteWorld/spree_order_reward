module Spree
  class OrderRewardAction < Spree::Base
    belongs_to :order_reward, class_name: 'Spree::OrderReward'
    scope :of_type, ->(t) { where(type: t) }

    def perform(_options = {})
      raise 'perform should be implemented in a sub-class of OrderRewardAction'
    end

    protected

    def label
      Spree.t(:order_reward_label, name: order_reward.name)
    end
  end
end
