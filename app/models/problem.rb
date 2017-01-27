# Contains a problem on one of the servers. Associated with submissions made
# against this problem and users who have made these submissions.
class Problem < ApplicationRecord
	belongs_to :server
	has_many :submissions
	has_many :accounts, through: :submissions

	# Since problems have both a shortname and a problem name, we hereby
	# define a display name, which is their shortname and their full name,
	# unless they are equal, in which case we return only one of them to
	# prevent looking silly.
	def display_name
		if short_name == name
			short_name
		else
			"#{short_name}: #{name}"
		end
	end
end
