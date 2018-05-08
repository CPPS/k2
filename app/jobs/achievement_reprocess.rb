require 'json'

class AchievementReprocess < ApplicationJob
 
  def perform()
  	file = File.read('achievements.json');
  	json = JSON.parse file;

    puts ""
  	puts "There are #{json['achievements'].length} achievements with unique keys."
    puts "Default image is stored at #{json['default_img']}"
    puts ""

  	puts "Parsed achievements:"
  	json['achievements'].each do |achievement|
      
      puts "  #{achievement['description']}"

      if not achievement['problems'].nil?    		
    		puts "    Problems:"
    		achievement['problems'].each do |p|
    			puts "     #{p}"
    		end 
      end

      if not achievement['levels'].nil?
        puts "    Levels:"
        achievement['levels'].each do |level|
          puts "     #{level}" 
        end unless achievement['levels'].nil?
      end

      if not achievement['prereqs'].nil?
        puts "    Required achievements:"
        achievement['prereqs'].each do |achiev|
          puts "     #{achiev}" 
        end unless achievement['prereqs'].nil?
      end

      if not achievement['variable'].nil?
        linker = if ["equal", "=", "==", "equals"].include? achievement['comparison'] then "" else "than " end
        puts "    #{achievement['variable']} #{achievement['comparison']} #{linker}#{achievement['value']}" 
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