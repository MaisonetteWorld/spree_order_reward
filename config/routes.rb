Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :order_rewards do
      resources :order_reward_rules
      resources :order_reward_actions
    end
  end
end
