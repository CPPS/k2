require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
	# Does not exist (yet)
	# test 'should get list' do
	#	get accounts_url
	#	assert_response :success
	# end

	test 'should get show' do
		get account_url(1)
		assert_response :success
	end

	# Requires authentication
	# test 'should get create' do
	#	get accounts_create_url
	#	assert_response :success
	# end

	# test 'should get delete' do
	#	get accounts_delete_url
	#	assert_response :success
	# end
end
