class Store < ActiveRecord::Base
	attr_accessor :address

	def address
		"#{self.address_1} #{self.address_2} #{self.city} #{self.state} #{self.zip}"
	end
end
