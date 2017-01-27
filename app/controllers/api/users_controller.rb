class Api::UsersController < Api::BaseController
	before_action :check_auth_token, only: [:logout, :stores]

	def login
		user = User.authenticate(params[:user][:email], params[:user][:password])
		if user.blank?
			render :json => {data: user, status: 0, message: "No user found."}
		else
			user.generate_token
			render :json => {data: user, status: 1, message: "Login Successfull."}
		end
	end

	def logout
		@user.clear_token
		render :json => {status: 1, message: "Logout Successfull."}
	end

	def stores
		stores = Store.all
		render :json => {data: stores, status: 1}
	end

	private
	def check_auth_token
		@user = User.find_by_auth_token(params["authtoken"])
		raise if @user.blank?
		rescue Exception => e
			render :json => {message: "No User Found", status: 0}
	end

end