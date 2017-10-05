module SpreeOrderReward
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_order_reward'

    config.autoload_paths += %W[#{config.root}/lib]

    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.order_reward.environment' do |app|
      app.config.spree.add_class('order_rewards')
      app.config.spree.order_rewards = Spree::Promo::Environment.new
      app.config.spree.order_rewards.rules = []
      app.config.spree.order_rewards.actions = []
    end

    config.after_initialize do
      Rails.application.config.spree.order_rewards
      Rails.application.config.spree.order_rewards.rules.concat [
        Spree::OrderReward::Rules::ItemTotal
      ]
      Rails.application.config.spree.order_rewards.actions.concat [
        Spree::OrderReward::Actions::PromoCode,
        Spree::OrderReward::Actions::PromoCodeForEvery,
        Spree::OrderReward::Actions::PromoCodeTier,
        Spree::OrderReward::Actions::StoreCredit,
        Spree::OrderReward::Actions::StoreCreditForEvery,
        Spree::OrderReward::Actions::StoreCreditTier
      ]
    end
  end
end
