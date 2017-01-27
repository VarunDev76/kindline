class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    def self.authenticate(email, password)
        user = User.find_for_authentication(:email => email)
        user.valid_password?(password) ? user : nil
    end

    def generate_token()
        token = SecureRandom.urlsafe_base64
        self.update_attributes(auth_token: token)
    end

    def clear_token
        self.update_attributes(auth_token: nil)
    end
end
