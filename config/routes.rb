Rails.application.routes.draw do
  namespace :admin do
    resources :flexi_shipping_rates
  end
end
