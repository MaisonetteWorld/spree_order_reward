class AddValidFromValidToToSpreeOrderRewards < ActiveRecord::Migration
  def change
    change_table :spree_order_rewards do |t|
      t.datetime :reward_valid_from, null: true
      t.datetime :reward_valid_to, null: true
    end
  end
end
