# This controller is responsible for rendering subsets of a scoreboard
class ScoreboardController < ApplicationController
	def show
		@accounts = Account.where(id: params[:account_ids].split(','))
		@problems = Problem.where(short_name: params[:problem_names].split(',')).order(short_name: :asc)
		problem_ids = @problems.map { |problem| problem.id.to_s }
		time_solved = Hash.new 0
		Submission.accepted.where(problem: @problems, account: @accounts).each do |sub|
			time_solved[sub.account_id] += sub.created_at.to_i
		end
		solved_problems = {}
		@accounts.each do |acc|
			solved_problems[acc.id] = (problem_ids & acc.solved_problem_ids).size
		end
		@accounts = @accounts.sort do |a, b|
			if solved_problems[a.id] == solved_problems[b.id]
				time_solved[a.id] - time_solved[b.id]
			else
				solved_problems[b.id] - solved_problems[a.id]
			end
		end
	end
end
