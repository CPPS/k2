require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	test 'should redirected to login when get list unauthenticated' do
		get users_url
		assert_response :redirect
		assert_redirected_to login_path
		follow_redirect!
		assert_response :success
	end

	test 'should get signup page' do
		get signup_url
		assert_response :success
	end

	test 'should be able to create user' do
		post users_url, params: {
			user: {
				name: 'a',
				username: 'bbbb',
				email: 'c@c.c',
				password: 'password',
				password_confirmation: 'password'
			}
		}
		assert_response :redirect
		# assert_redirected_to user_path
		# TODO: check redirected to correct user & logged in
		follow_redirect!
		assert_response :success
	end
end
