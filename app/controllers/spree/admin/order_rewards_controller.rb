module Spree
  module Admin
    class OrderRewardsController < ResourceController
      helper 'spree/order_reward_rules'

      protected

      def location_after_save
        spree.edit_admin_order_reward_url(@order_reward)
      end

      def collection_from_search
        @search.
          result(distinct: true).
          includes(order_reward_includes).
          page(params[:page]).
          per(params[:per_page] || 25)
      end

      def collection
        return @collection if defined?(@collection)
        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= 'id desc'

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = collection_from_search
      end

      def order_reward_includes
        [:order_reward_actions]
      end
    end
  end
end
