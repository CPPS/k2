require 'json'

class AchievementReprocess < ApplicationJob
 
  def perform()
  	file = File.read('achievements.json');
  	json = JSON.parse file;

  	puts "There are #{json.values.count} achievements with unique keys."

  	puts "Parsed achievements:"
  	json.each do |name, achievement|
  		puts name
  		puts "  Achievements:"
  		achievement['problems'].each do |p|
  			puts "     #{p}"
  		end unless achievement['problems'].nil?

      achievement['achievements'].each do |achiev|
        puts "     #{achiev}" 
      end unless achievement['achievements'].nil?

      if not achievement['variable'].nil?
        linker = if ["equal", "=", "==", "equals"].include? achievement['comparison'] then "" else "than " end
        puts "     #{achievement['variable']} #{achievement['comparison']} #{linker}#{achievement['value']}" 
      end
    end

    puts "Do you want to reprocess all submissions? (y/n)"
    answer = gets.chomp
    if answer != "y"
      return 
    end

    Submission.delete_all
    Achievement.delete_all
    Server.where(api_type: "domjudge").each do |s|
      s.last_judging = 0
      s.save!
    end    
	end
end