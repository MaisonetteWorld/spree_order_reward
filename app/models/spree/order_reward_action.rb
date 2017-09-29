module Spree
  class OrderRewardAction < Spree::Base
    belongs_to :order_reward, class_name: 'Spree::OrderReward'
    scope :of_type, ->(t) { where(type: t) }

    def eligible?(_order)
      true
    end

    def perform(_order, _options = {})
      raise 'perform should be implemented in a sub-class of OrderRewardAction'
    end

    def customer_description(_order)
      ''
    end

    protected

    def label
      Spree.t(:order_reward_label, name: order_reward.name)
    end
  end
end
