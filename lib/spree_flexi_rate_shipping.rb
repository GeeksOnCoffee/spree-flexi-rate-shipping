require 'spree_core'
require 'spree_flexi_rate_shipping_hooks'

module SpreeFlexiRateShipping
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      Calculator::FlexiShippingRate.register
      
      ShippingCategory.class_eval do
        has_many :flexi_shipping_rates
      end
      
      Zone.class_eval do
        has_many :flexi_shipping_rates
      end
      
    end

    config.to_prepare &method(:activate).to_proc
  end
end
