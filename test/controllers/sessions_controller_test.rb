require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
	test 'should get login page (new)' do
		get login_url
		assert_response :success
	end

	test 'should get create' do
		post login_url, params: { session:
			    { user: 'MyString', password: 'MyString' } }
		assert_response :success
	end

	# Not nice: SessController does not check if you are logged in or not
	test 'should get destroy' do
		delete logout_url
		assert_response :redirect
	end
end
