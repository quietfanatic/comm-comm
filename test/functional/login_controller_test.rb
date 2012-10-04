require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test "should get entrance" do
    get :entrance
    assert_response :success
  end

end
