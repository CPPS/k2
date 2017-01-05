class ServersController < ApplicationController

	def index
		@servers = Server.all
	end

	def show
		@server = Server.find(params[:id])
		@feed = @server.submissions.includes(:account, :problem).order(submission_id: :desc).references(:accounts, :problems).limit(10)
		@problems = @server.problems.order(short_name: :asc)
		total_subs = Submission.select("problem_id, count(distinct account_id) as total").group("problem_id")
		total_acsubs = Submission.select("problem_id, count(distinct account_id) as total").where(accepted: true).group("problem_id")
		@problem_subs = {}
		total_subs.each { |s| @problem_subs[s.problem_id] = s.total }
		@problem_acsubs = {}
		total_acsubs.each { |s| @problem_acsubs[s.problem_id] = s.total }

	#	get_attempted @problems if logged_in?
#			if has_account?(@server)
#				attempted = @problems.includes(:submissions).where(submissions: { account: get_account(@server), accepted: false}).references(:submissions)
#				solved = @problems.includes(:submissions).where(submissions: { account: get_account(@server), accepted: true}).references(:submissions)
#				@user_attempted = {}
#				attempted.each do |p|
#					@user_attempted[p.id] = false
#				end
#				solved.each do |p|
##					@user_attempted[p.id] = true
#				end
#			else
#				@user_attempted = {}
#			end
#		end
		@accounts = @server.accounts.order(solvedProblems: :desc, score: :asc)
	end
end
