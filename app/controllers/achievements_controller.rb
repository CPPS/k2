class AchievementsController < ApplicationController
	def show
		@shield_files = ['shield_platinum.png', 'shield_gold.png', 'shield_silver.png', 'shield_bronze.png']
		#@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
		@achievement_data = AchievementDatum.all.where.not(kind: :first_to_solve).order(
			tier: :desc, title: :asc
		)
	end
end
