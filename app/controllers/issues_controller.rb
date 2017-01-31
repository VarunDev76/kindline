class IssuesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_issue, only: [:show, :edit, :update, :destroy]

	def index
  		@issues = Issue.all
	end

	def new
		@issue = Issue.new
	end

	def create
		@issue = Issue.new(issue_params)
		if @issue.save
			redirect_to issues_url, notice: "Issue was successfully created."
		else
			render :new
		end
	end

	def edit
		
	end

	def update
		if @issue.update(issue_params)
	    	redirect_to issues_url, notice: 'Issue was successfully updated.'
	    else
	    	render :edit
	    end
	end

	def show
		
	end

	def destroy
		@issue.destroy
		redirect_to issues_url, notice: 'Issue was successfully deleted.'
	end

	private

	def set_issue
      @issue = Issue.find(params[:id])
    end

	def issue_params
		params.require(:issue).permit(:name, :quantity, :amount)
	end
end
