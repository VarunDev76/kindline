class Sale < ActiveRecord::Base
	has_one :payment
end
