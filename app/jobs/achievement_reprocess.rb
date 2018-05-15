require 'json'

class AchievementReprocess < ApplicationJob
 
  def perform(delete_old = false)   
    if delete_old 
      Achievement.destroy_all
      AchievementDatum.where(kind: :first_to_solve).destroy_all   
    end

    if false
      Submission.delete_all
      Server.where(api_type: "domjudge").each do |s|
        s.last_judging = 0
        s.save!
      end
    end

    Submission.order(:judged_at).where(status: :correct).each do |s|
      s.on_correct_submission
    end    
	end
end