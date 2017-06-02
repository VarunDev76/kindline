class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    def self.authenticate(email, password)
        user = User.find_for_authentication(:email => email)
        user.valid_password?(password) ? user : nil
    end

    def generate_token
        token = SecureRandom.urlsafe_base64
        self.update_attributes(auth_token: token)
    end

    def clear_token
        self.update_attributes(auth_token: nil)
    end
    # def self.to_csv
    # binding.pry
      # CSV.generate do |csv|
      #   csv << column_names
      #   all.each do |product|
      #     csv << product.attributes.values_at(*column_names)
      #   end
      # end
    # end
    # def to_csv(options = Hash.new)
    #     binding.pry
    #     # override only if first element actually has as_csv method
    #     return old_to_csv(options) unless self.first.respond_to? :as_csv
    #     # use keys from first row as header columns
    #     out = first.as_csv.keys.to_csv(options)
    #     self.each { |r| out << r.as_csv.values.to_csv(options) }
    #     out
    # end
    def self.to_csv(options = {})
        binding.pry
        CSV.generate(options) do |csv|
        csv << column_names
        all.each do |product|
             csv << product.attributes.values_at(*column_names)
        end
    end
  end
end
