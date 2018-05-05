class Achievement < ApplicationRecord
	belongs_to :user
	enum type: [:general, :first_to_solve ]
end
