class CreateSpreeRewardRules < ActiveRecord::Migration
  def change
    create_table "spree_order_reward_rules", force: :cascade do |t|
      t.integer  "order_reward_id"
      t.integer  "user_id"
      t.integer  "product_group_id"
      t.string   "type"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.string   "code"
      t.text     "preferences"
    end
  end
end
