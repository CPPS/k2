object :@problem
extends 'api/v1/problems/base'
child :submissions do
	attributes :account_id, :accepted, :status, :score, :created_at
end
