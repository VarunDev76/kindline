class UserController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	# skip_before_filter  :verify_authenticity_token, only: [:submit_quote]

	def authenticate
	    callback = quickbooks_oauth_callback_url
	    token = QB_OAUTH_CONSUMER.get_request_token(:oauth_callback => callback)
	    session[:qb_request_token] = token
	    redirect_to("https://a''ppcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
	end

	def oauth_callback
		at = session[:qb_request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
		token = at.token
		secret = at.secret
		realm_id = params['realmId']
		# store the token, secret & RealmID somewhere for this user, you will need all 3 to work with Quickbooks-Ruby
	end

	def index
  		# if current_user.admin?
  			@users = User.all #.where(admin: false)
	  	# else
	  		# @user = current_user
	  	# end
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
    	@issues = Issue.all
    	# binding.pry
    	
    end

    def excel
    	# @users = User.all.where(admin: false)
    	# @sales = Sale.order(:id)
    	# drop_qty = params[:drop_qty]
    	# pick_qty = params[:pick_qty]
    	# sale = params[:sale]
    	# issue = params[:issue]
    	# @params = drop_qty + " " + pick_qty + " " + sale + " " + issue
    	# @params = @params.split(" ")
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

    	@issue = Issue.where(id: params[:issue]).first
    	if @issue.blank?
    		issue_ids = Issue.all.map(&:id)
    	else
    		issue_ids = @issue.id
    	end

    	# binding.pry
		# @result = Sale.where("created_at >= :start_date AND created_at <= :end_date", {start_date: params[:starting_date], end_date: params[:ending_date]})
    	@data = Sale.where(user_id: user_ids, store_id: store_ids , issue_id: issue_ids)#.group_by(&:issue_id)

    	@products = @data
    	binding.pry
		respond_to do |format|
			format.html
			format.csv { send_data @products.to_csv }
			format.xls { send_data @products.to_csv(col_sep: "\t") }
		end
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

    	@issue = Issue.where(id: params[:issue]).first
    	if @issue.blank?
    		issue_ids = Issue.all.map(&:id)
    	else
    		issue_ids = @issue.id
    	end

    	# binding.pry
		@result = Sale.where("created_at >= :start_date AND created_at <= :end_date", {start_date: params[:starting_date], end_date: params[:ending_date]})
    	@data = Sale.where(user_id: user_ids, store_id: store_ids , issue_id: issue_ids , id: @result.ids ).group_by(&:issue_id)
		# binding.pry
		

    end

	private

	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end