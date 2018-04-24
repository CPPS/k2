require 'test_helper'

class ChangelogControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get changelog_index_url
    assert_response :success
  end

end
