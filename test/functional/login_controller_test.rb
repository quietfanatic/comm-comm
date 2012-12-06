require 'test_helper'

class LoginControllerTest < ActionController::TestCase
	test "should get entrance" do
		visit '/login/entrance'
		assert_response :success, "Entrance does not exist or cannot be reached."
	end
  
	test "should get journey" do
		visit '/login/journey'
		assert_response :success, "Journey does not exist or cannot be reached."
	end
	
	test "should get signup" do
		visit '/login/signup'
		assert_response :success, "Signup does not exist or cannot be reached."
	end

end
