class CreateSpreeRewardActions < ActiveRecord::Migration
  def change
    create_table "spree_order_reward_actions", force: :cascade do |t|
      t.integer  "order_reward_id"
      t.integer  "position"
      t.string   "type"
      t.datetime "deleted_at"
      t.text     "preferences"
    end
    add_index "spree_order_reward_actions",
              ["deleted_at"], name: "index_spree_order_reward_actions_on_deleted_at", using: :btree
    add_index "spree_order_reward_actions",
              ["id", "type"], name: "index_spree_order_reward_actions_on_id_and_type", using: :btree
    add_index "spree_order_reward_actions",
              ["order_reward_id"], name: "index_spree_order_reward_actions_on_order_reward_id", using: :btree
  end
end
