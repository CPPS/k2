class AchievementDatum < ApplicationRecord
	has_many :problem_entries, :dependent => :destroy
	has_many :level_entries, :dependent => :destroy
	has_many :achievements, :dependent => :destroy

	enum kind: [:general, :category, :first_to_solve ]
end
