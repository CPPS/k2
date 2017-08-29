# Models a user of our application
# A user can log in and is linked to accounts on servers
class User < ApplicationRecord
	has_many :accounts
	has_many :servers, through: :account

	before_save { email.downcase! }

	validates :name,
	          presence: true

	validates :username,
	          presence: true,
	          length: { minimum: 4 },
	          uniqueness: { case_sensitive: false }

	validates :email,
	          presence: true,
	          length: { minimum: 5 }, # TODO: proper regex
	          uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password,
	          presence: true,
	          allow_nil: true,
	          length: { minimum: 6 }

	attr_accessor :session_token

	# Return the digest of a given string
	def self.digest(string)
		cost = if ActiveModel::SecurePassword.min_cost
			       BCrypt::Engine::MIN_COST
		       else
			       BCrypt::Engine.cost
		       end
		BCrypt::Password.create string, cost: cost
	end

	# Create a new session token
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# Create a new session token for this user and updates its digest.
	def create_session
		self.session_token = User.new_token
		update_attribute :session_token_digest, User.digest(session_token)
	end

	# Delete the session token
	def destroy_session
		update_attribute :session_token_digest, nil
	end

	# Return true iff the session token matches
	def authenticated?(session_token)
		BCrypt::Password.new(session_token_digest).is_password? session_token
	end
end
