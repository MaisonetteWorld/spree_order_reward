class Spree::Admin::OrderRewardActionsController < Spree::Admin::BaseController
  before_action :load_order_reward, only: %i[create destroy]
  before_action :validate_order_reward_action_type, only: :create

  def create
    @order_reward_action = params[:action_type].constantize.new(params[:order_reward_action])
    @order_reward_action.order_reward = @order_reward
    if @order_reward_action.save
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:order_reward_action))
    end
    respond_to { |format| respond(format) }
  end

  def destroy
    @order_reward_action = @order_reward.order_reward_actions.find(params[:id])
    if @order_reward_action.destroy
      flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:order_reward_action))
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

  def validate_order_reward_action_type
    if !application_config_order_rewards.actions.map(&:to_s).include?(params[:action_type])
      flash[:error] = Spree.t(:invalid_order_reward_action)
      respond_to { |format| respond(format) }
    end
  end
end
