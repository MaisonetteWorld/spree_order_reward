class Spree::Admin::OrderRewardRulesController < Spree::Admin::BaseController
  helper 'spree/order_reward_rules'

  before_action :load_order_reward, only: %i[create destroy]
  before_action :validate_order_reward_rule_type, only: :create

  def create
    # Remove type key from this hash so that we don't attempt
    # to set it when creating a new record, as this is raises
    # an error in ActiveRecord 3.2.
    order_reward_rule_type = params[:order_reward_rule].delete(:type)
    @order_reward_rule = order_reward_rule_type.constantize.new(params[:order_reward_rule])
    @order_reward_rule.order_reward = @order_reward
    if @order_reward_rule.save
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:order_reward_rule))
    end
    respond_to { |format| respond(format) }
  end

  def destroy
    @order_reward_rule = @order_reward.order_reward_rules.find(params[:id])
    if @order_reward_rule.destroy
      flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:order_reward_rule))
    end
    respond_to { |format| respond(format) }
  end

  private

  def application_config_order_rewards
    Rails.application.config.spree.order_rewards
  end

  def load_order_reward
    @order_reward = Spree::OrderReward.find(params[:order_reward_id])
  end

  def respond(format)
    format.html { redirect_to spree.edit_admin_order_reward_path(@order_reward) }
    format.js   { render layout: false }
  end

  def validate_order_reward_rule_type
    if !application_config_order_rewards.rules.map(&:to_s).include?(params[:order_reward_rule][:type])
      flash[:error] = Spree.t(:invalid_order_reward_rule)
      respond_to { |format| respond(format) }
    end
  end
end
