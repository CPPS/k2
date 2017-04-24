require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
	# test "the truth" do
	#   assert true
	# end
	
	test 'should get index' do
		get problems_url
		assert_response :success
	end

	test 'should get show' do
		get kaas_url(1, 'T1')
		assert_response :success
	end
end
