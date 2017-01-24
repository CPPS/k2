require 'test_helper'

class Api
	class V1
		class ProblemsControllerTest < ActionDispatch::IntegrationTest
			test 'should get index' do
				get api_v1_problems_url('json')
				assert_response :success
				get api_v1_problems_url('xml')
				assert_response :success
			end

			test 'should get show' do
				get api_v1_problem_url(1, 'json')
				assert_response :success
				get api_v1_problem_url(1, 'xml')
				assert_response :success
			end
		end
	end
end
