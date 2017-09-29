class AddValidFromValidToToSpreeStoreCredits < ActiveRecord::Migration
  def change
    change_table :spree_store_credits do |t|
      t.datetime :valid_from, null: true
      t.datetime :valid_to, null: true
    end
  end
end
