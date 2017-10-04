module Spree
  class PromoGenerator
    attr_accessor :promotion

    def initialize(type, options = {})
      validate_required_options(type, options)
      if types[type].present?
        ActiveRecord::Base.transaction do
          @promotion = send(types[type], options)
        end
      else
        false
      end
    end

    def required_options
      ### Available options
      # :valid_from - datetime
      # :valid_to - datetime
      # :label - string
      # :code - string
      # :currency - dec
      # :usage_limit - int
      # :amount - dec
      # :user - Spree::User
      # :advertise - bool
      {
        user_code_flat: %i[user amount]
      }
    end

    def types
      ### Available generator types
      # user_code_flat: Promo Code dedicated for a single user. Flat rate amount
      {
        user_code_flat: :build_user_code_flat_promotion
      }
    end

    private

    def build_user_code_flat_promotion(options)
      options[:code] = options[:code] || generate_code
      options[:usage_limit] = options[:usage_limit] || 1
      options[:label] = options[:label] || "Single Code Promo For #{options[:user].email}"

      promotion = create_promotion(options)
      create_flat_rate_action(promotion, options)
      create_user_rule(promotion, options)
      promotion
    end

    def create_promotion(options)
      # Create promotion
      Spree::Promotion.create!(
        starts_at: options[:valid_from],
        expires_at: options[:valid_to],
        usage_limit: options[:usage_limit] || 1,
        name: options[:label],
        code: options[:code],
        advertise: options[:advertise] || false,
        description: options[:description] || ''
      )
    end

    def create_flat_rate_action(promotion, options)
      # Create promotion rule
      currency = options[:currency] || Spree::Config[:currency]
      action = Spree::Promotion::Actions::CreateAdjustment.create!(
        promotion: promotion,
        type: 'Spree::Promotion::Actions::CreateAdjustment'
      )

      # Delete default rates
      Spree::Calculator.where(
        calculable_id: action.id,
        calculable_type: 'Spree::PromotionAction',
      ).each(&:destroy)

      # Create flat rate calculator
      Spree::Calculator::FlatRate.create!(
        type: 'Spree::Calculator::FlatRate',
        calculable_id: action.id,
        calculable_type: 'Spree::PromotionAction',
        preferences: {
          currency: currency,
          amount: BigDecimal(options[:amount])
        }
      )
      action
    end

    def create_user_rule(promotion, options)
      # Create Promotion rule and match it with user
      rule = Spree::PromotionRule.create!(
        promotion: promotion,
        type: 'Spree::Promotion::Rules::User'
      )
      Spree::PromotionRuleUser.create!(
        user: options[:user],
        promotion_rule: rule
      )
      rule
    end

    def generate_code(length = 8)
      code = ''
      length.times { code << (65 + rand(25)).chr }
      code
    end

    def validate_required_options(type, options)
      if required_options[type].present?
        required_options[type].each do |option_key|
          if options[option_key].blank?
            raise "#{option_key} cannot be blank"
          end
        end
      end
      true
    end
  end
end
