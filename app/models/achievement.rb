class Achievement < ApplicationRecord
	belongs_to :user
	belongs_to :achievement_datum
	enum kind: [:general, :first_to_solve ]
end
