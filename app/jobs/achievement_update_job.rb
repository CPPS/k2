require 'json'

class AchievementUpdateJob < ApplicationJob
 
  def perform(user, judged_at) #user, judged_at)

	if (user.nil? or user.accounts.nil?)
		return
	end

  	file = File.read('achievements.json')
  	json = JSON.parse file
  
  	account = user.accounts.first # Assume first account is domjudge account
  	
  	variables = {}

  	if not account.score.nil?
  	variables['ranking'] = Account.all.where.not(score: nil).order(
			solvedProblems: :desc, score: :asc
		).index(account) + 1
	else 
		variables['ranking'] = 99999
	end
  	variables['solvedProblems'] = account.solvedProblems
  	
   	recheck_all = false
  	json.each do |name, achievement|
  		next if user.achievements.where(name: name).exists?

  		completed = true
		achievement['problems'].each do |p|
			if not account.submissions.joins(:problem).where("problems.short_name" => p).exists?
				completed = false
				break		
			end
		end unless achievement['problems'].nil?

		if not achievement['variable'].nil?
			case achievement['comparison']
			when "greater", "bigger", "larger", ">"
				completed = eval("variables[achievement['variable']] > achievement['value']") unless not completed # Only allow completed to be set to false, not to true			
			when "equal", "=", "==", "equals"
				completed = eval("variables[achievement['variable']] == achievement['value']") unless not completed # Only allow completed to be set to false, not to true			
			when "less", "smaller", "fewer", ">"
				completed = eval("variables[achievement['variable']] < achievement['value']") unless not completed # Only allow completed to be set to false, not to true
			end
		end

		achievement['achievements'].each do |achiev|
			if not user.achievements.where(name: achiev).exists?
				completed = false
				break		
			end
		end unless achievement['achievements'].nil?

		if completed
			new_achievement = Achievement.new({'descr' => achievement['description'], 'user_id' => user.id, 'date_of_completion' => judged_at, 'name': name })
			new_achievement.save!			

			recheck_all = true # Check for existing achievements that may depend on this one
		end
	end

	perform(user, judged_at) unless not recheck_all
  end
end