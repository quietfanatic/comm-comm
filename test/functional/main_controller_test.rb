require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get topic" do
    get :topic
    assert_response :success
  end

end
