class CreateSpreeRewards < ActiveRecord::Migration
  def change
    create_table "spree_order_rewards", force: :cascade do |t|
      t.string   "description"
      t.datetime "expires_at"
      t.datetime "starts_at"
      t.string   "name"
      t.integer  "usage_limit"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "spree_order_rewards",
              ["expires_at"], name: "index_spree_order_rewards_on_expires_at", using: :btree
    add_index "spree_order_rewards",
              ["starts_at"], name: "index_spree_order_rewards_on_starts_at", using: :btree
  end
end
