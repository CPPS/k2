class AchievementsController < ApplicationController
	def show
		@shield_files = ['\assets\shield_platinum', '\assets\shield_gold', '\assets\shield_silver', '\assets\shield_bronze']
		#@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
		@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
			tier: :desc, title: :asc
		)
	end
end