class Calculator::FlexiShippingRate < Calculator
  
  def self.description
    I18n.t("flexible_rate") + "- Categories"
  end

  def self.available?(object)
    sc = object.line_items.collect{|li| li.product.shipping_category}
    return false if sc.any?{|c| c.nil?}
    return true
  end
  
  def self.register
    super
    ShippingMethod.register_calculator(self)
  end
  
  def compute(object)
      rates = {}
      rate_count = {}
      object.line_items.each do |li|

        li.quantity.times do 
          sc = li.variant.product.shipping_category
          return false if sc.nil?
          flexi_rates = sc.flexi_shipping_rates
           
          fsr = flexi_rates.detect{ | rate | rate.zone.include?(ship_address = (object.class == Shipment) ? object.order.ship_address : object.ship_address) }
        
          rate_count.has_key?(fsr.id) ? rate_count[fsr.id] += 1 : rate_count[fsr.id] = 1

          rates[fsr.id] = 0 unless rates.has_key? fsr.id

          if rates[fsr.id] == 0
            #first time to add a product from this flexi-rate
            rates[fsr.id] +=  fsr.first_item_price
          else
            #additional time to add a product from this flexi-rate

            if rate_count[fsr.id] % fsr.max_items == 1
              rates[fsr.id] += fsr.first_item_price
            else
              rates[fsr.id] += fsr.additional_item_price
            end

          end
        end

      end

      return rates.values.inject(0){|sum, c| sum + c}
  end
  
end