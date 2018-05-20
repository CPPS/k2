require 'test_helper'

class AchievementsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get achievements_show_url
    assert_response :success
  end

end
