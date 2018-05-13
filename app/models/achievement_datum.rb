class AchievementDatum < ApplicationRecord
	has_many :problem_entries
	has_many :level_entries
	has_many :achievements	

	enum kind: [:general, :category, :first_to_solve ]
end
