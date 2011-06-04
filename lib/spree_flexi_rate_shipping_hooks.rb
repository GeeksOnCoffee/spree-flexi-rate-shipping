class SpreeFlexiRateShippingHooks < Spree::ThemeSupport::HookListener
   insert_after :admin_configurations_menu do
     "<%= configurations_menu_item('Flexible Rate Shipping', admin_flexi_shipping_rates_path, 'Flexible Rate Shipping') %>"
   end
end