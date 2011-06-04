class Admin::FlexiShippingRatesController < Admin::ResourceController   
    before_filter :load_data
    layout 'admin'

    private 
	
	    def load_data     
	      @available_categories = ShippingCategory.find :all, :order => :name
	      @available_zones = Zone.find :all, :order => :name
	    end
end
