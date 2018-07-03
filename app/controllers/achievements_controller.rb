class AchievementsController < ApplicationController
	def show
		@shield_files = ['shield_platinum', 'shield_gold', 'shield_silver', 'shield_bronze']
		#@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
		@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
			tier: :desc, title: :asc
		)
	end
end
