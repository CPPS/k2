require 'json'

class AchievementUpdateJob < ApplicationJob
 
  def perform(user, judged_at)  	
	return unless not user.nil? and not user.accounts.nil?
  	
  	account = user.accounts.first # Assume first account is domjudge account  	
  	variables = lookup_stats account
  	
   	recheck_all = false
  	AchievementDatum.where(kind: :general).each do |achievement|
  		next if user.achievements.where(achievement_datum_id: achievement.id).exists? or not achievement.general?

  		completed = true
		
		completed = check_problems achievement, account unless not completed		
		completed = check_variables achievement, variables unless not completed
		#completed = check_prereqs achievement, user unless not completed		

		if completed			
			create_achievement(user, judged_at, achievement, :general, 0)
			#recheck_all = true # Check for existing achievements that may depend on this one
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

  def create_achievement(user, judged_at, achievement, kind, level)
  	new_achievement = Achievement.new({
		 'user_id' => user.id, 
		 'date_of_completion' => judged_at,
		 'achievement_datum_id' => achievement.id
		 })
	new_achievement.save!		
  end

  def check_problems(achievement, account)
	achievement.problem_entries.each do |p|
		if not account.submissions.joins(:problem).where("problems.short_name" => p.value).exists?
			return false 
		end
	end 

	return true
  end

  def check_and_update_level(achievement, account, user, judged_at)
  	# first evaluate what level the user would reach
  	level = 0
	achievement.level_entries.each do |p|
		if account.submissions.joins(:problem).where("problems.short_name" => p.value).exists?
			level+=1 
		else
			break
		end
	end
	# if no problems have been completed, no change has to be made
	if level == 0
		return # no change
	end
	# check existing achievements for highest level reached
	maxLevelAch = user.achievements.where(name: achievement['id']).order("level DESC").first
	if not maxLevelAch.nil?
		# only record change if level has risen
		level = if maxLevelAch.level < level then level else 0 end
	end
	# if level has changed, create new achievement and make previous invisible
	if level == 0
		return
	end
	if not maxLevelAch.nil?
		maxLevelAch.isActive = false
		maxLevelAch.save!
	end
	create_achievement(user, judged_at, achievement, :category, level)
  end

  def check_variables(achievement, variables)
	if not achievement.variable.nil?
		case achievement['comparison']
		when "greater", "bigger", "larger", ">="
			return eval("variables[achievement.variable] >= achievement['value']") 
		when "equal", "=", "==", "equals"
			return eval("variables[achievement.variable] == achievement['value']")			
		when "less", "smaller", "fewer", "<="
			return eval("variables[achievement.variable] <= achievement['value']") 
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