require 'test_helper'

class Api
	class V1
		class ServersControllerTest < ActionDispatch::IntegrationTest
			test 'should get index' do
				get api_v1_servers_url('json')
				assert_response :success
			end

			test 'should get show' do
				get api_v1_server_url(1, 'json')
				assert_response :success
			end
		end
	end
end
