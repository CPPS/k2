require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
	test "get index" do
		get root_url
		assert_response :success
	end
end
