Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_promotion',
  name: 'admin_add_order_rewards_to_promotion_menu',
  insert_bottom: '[data-hook="admin_promotion_sub_tabs"]',
  text: '<%= tab :order_rewards, label: "Order Rewards", match_path: "/order_rewards" %>'
)
