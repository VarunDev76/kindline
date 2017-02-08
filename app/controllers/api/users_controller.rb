class Api::UsersController < Api::BaseController
	before_action :check_auth_token, only: [:logout, :stores, :issues, :save_issue_qty]

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

	def issues
		@store = Store.where(id: params[:store_id]).first
		if @store.blank?
			render :json => {status: 0, message: "No Store Found."}
		else
			# @data = Sale.where(user_id: @user.id, store_id: @store.id).first
			# if @data.blank?
			# 	last_issue_drop_qty = 0
			# 	last_issue_picked_id = ""
			# 	current_issue_drop_id = Issue.last.id
			# 	current_issue_drop_ref_id = Issue.last.try(:name)
			# else
			# 	last_issue_drop_qty = @data.drop_qty
			# 	last_issue_picked_id = @data.issue_id
			# 	last_issue_picked_ref_id = Issue.where(id: @data.issue_id).first.name
			# 	current_issue_drop_id = Issue.last.id
			# 	current_issue_drop_ref_id = Issue.last.try(:name)
			# end
			# render :json => { last_issue_drop_qty: last_issue_drop_qty, current_issue_drop_id: current_issue_drop_id, current_issue_drop_ref_id: current_issue_drop_ref_id,
			#  last_issue_picked_id: last_issue_picked_id,last_issue_picked_ref_id: last_issue_picked_ref_id}


			 render :json => { 
			 	store_id: @store.id,
			 	last_issue_drop_qty: @store.drop_qty,
			 	current_issue_drop_id: Issue.last.try(:id), 
			 	current_issue_drop_name: Issue.last.try(:name), 
			 	last_issue_picked_id: @store.current_issue_id}
		end
	end

	def save_issue_qty
		@store = Store.where(id: params[:store_id]).first
		data = Sale.where(user_id: @user.id, store_id: @store.id)
		unless params[:data][:current_issue_drop_id].blank?
			obj=data.find_or_create_by(issue_id: params[:data][:current_issue_drop_id])
			obj.issue_id = params[:data][:current_issue_drop_id]
			obj.drop_qty = obj.drop_qty+params[:data][:current_issue_drop_qty].to_i
			obj.save
		end

		issue = Sale.where(store_id: @store.id, issue_id: params[:data][:last_issue_picked_id]).first

		if issue.blank?
			unless params[:data][:last_issue_picked_id].blank?
				obj=data.find_or_create_by(issue_id: params[:data][:last_issue_picked_id])
				obj.issue_id = params[:data][:last_issue_picked_id]
				obj.pick_qty = obj.pick_qty + params[:data][:last_picked_issue_qty].to_i
				obj.save
			end
		else
			issue.pick_qty = issue.pick_qty + params[:data][:last_picked_issue_qty].to_i
			issue.save
		end
		
		if @store.current_issue_id.to_i == params[:data][:current_issue_drop_id].to_i
			@store.drop_qty = @store.drop_qty + params[:data][:current_issue_drop_qty].to_i
		else
			@store.drop_qty = params[:data][:current_issue_drop_qty].to_i
		end
		@store.current_issue_id = params[:data][:current_issue_drop_id]
		@store.save
		render :json => {status: 1}
	end

	private
	def check_auth_token
		@user = User.find_by_auth_token(params["authtoken"])
		raise if @user.blank?
		rescue Exception => e
			render :json => {message: "No User Found", status: 0}
	end

end