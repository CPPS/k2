class Achievement < ApplicationRecord
	belongs_to :user
	enum kind: [:general, :category, :first_to_solve ]
end
