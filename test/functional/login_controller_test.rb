require 'test_helper'

class LoginControllerTest < ActionController::TestCase
	test "should get entrance" do
		visit '/login/entrance'
		assert_response :success
	end
  
	test "should get journey" do
		visit '/login/journey'
		assert_response :success
	end
	
	test "should get signup" do
		visit '/login/signup'
		assert_response :success
	end

end
