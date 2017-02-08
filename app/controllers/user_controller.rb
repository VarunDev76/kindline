class UserController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	# skip_before_filter  :verify_authenticity_token, only: [:submit_quote]

	def index
  		if current_user.admin?
  			@users = User.all.where(admin: false)
	  	else
	  		@user = current_user
	  	end
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to user_index_url, notice: "User was successfully created."
		else
			render :new
		end
	end

	def edit
		
	end

	def update
		if @user.update(user_params)
	    	redirect_to user_index_url, notice: 'User was successfully updated.'
	    else
	    	render :edit
	    end
	end

	def show
		
	end

	def destroy
		@user.destroy
		redirect_to user_index_url, notice: 'User was successfully deleted.'
	end

	def report
    	@users = User.all.where(admin: false)
    	@stores = Store.all
    end

    def search
    	@user = User.where(id: params[:user]).first
    	if @user.blank?
    		user_ids = User.where(admin: false).map(&:id)
    	else
    		user_ids = @user.id
    	end

    	@store = Store.where(id: params[:store]).first
    	if @store.blank?
    		store_ids = Store.all.map(&:id)
    	else
    		store_ids = @store.id
    	end
    	@data = Sale.where(user_id: user_ids, store_id: store_ids).group_by(&:issue_id)
    end

	private

	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end