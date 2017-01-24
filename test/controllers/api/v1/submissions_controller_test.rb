require 'test_helper'

class Api
	class V1
		class SubmissionsControllerTest < ActionDispatch::IntegrationTest
			test 'should get index' do
				get api_v1_submissions_url('json')
				assert_response :success
				get api_v1_submissions_url('xml')
				assert_response :success
			end

			test 'should get show' do
				get api_v1_submission_url(1, 'json')
				assert_response :success
				get api_v1_submission_url(1, 'xml')
				assert_response :success
			end
		end
	end
end
