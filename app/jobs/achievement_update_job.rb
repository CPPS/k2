require 'json'

class AchievementUpdateJob < ApplicationJob
 
  def perform(user, judged_at)
	return unless not user.nil? and not user.accounts.nil?

  	file = File.read('achievements.json')
  	data = JSON.parse file  
  	account = user.accounts.first # Assume first account is domjudge account  	
  	variables = lookup_stats account
  	
   	recheck_all = false
  	data['achievements'].each do |achievement|
  		next if user.achievements.where(name: achievement['id']).exists?

  		completed = true
		
		completed = check_problems achievement, account unless not completed
		completed = check_variables achievement, variables unless not completed
		completed = check_prereqs achievement, user unless not completed		

		if completed			
			create_achievement(user, judged_at, achievement, data)
			recheck_all = true # Check for existing achievements that may depend on this one
		end
	end

	AchievementUpdateJob.perform_now(user, judged_at) unless not recheck_all
  end

  def lookup_stats(account) 
  	variables = {}

  	if not account.score.nil?
  		variables['ranking'] = Account.all.where.not(score: nil).order(
			solvedProblems: :desc, score: :asc
		).index(account) + 1
	else 
		variables['ranking'] = 99999
	end
  	variables['solvedProblems'] = account.solvedProblems

  	variables
  end

  def create_achievement(user, judged_at, achievement, data)
  	if achievement['img'].nil?
		filename = data['default_img']
	else 
		filename = achievement['img']
	end

	new_achievement = Achievement.new({
		'descr' => achievement['description'],
		 'user_id' => user.id, 
		 'date_of_completion' => judged_at,
		 'name' => achievement['id'], 
		 'filename' => filename,
		 'title' => achievement['title']})
	new_achievement.save!		
  end

  def check_problems(achievement, account)
	achievement['problems'].each do |p|
		if not account.submissions.joins(:problem).where("problems.short_name" => p).exists?
			return false 
		end
	end unless achievement['problems'].nil?

	return true
  end

  def check_variables(achievement, variables)
	if not achievement['variable'].nil?
		case achievement['comparison']
		when "greater", "bigger", "larger", ">"
			return eval("variables[achievement['variable']] > achievement['value']") 
		when "equal", "=", "==", "equals"
			return eval("variables[achievement['variable']] == achievement['value']")			
		when "less", "smaller", "fewer", ">"
			return eval("variables[achievement['variable']] < achievement['value']") 
		end
	end
	return true
  end

  def check_prereqs(achievement, user)
  	achievement['prereqs'].each do |achiev|
		if not user.achievements.where(name: achiev).exists?
			return false	
		end
	end unless achievement['prereqs'].nil?
	return true
  end

end