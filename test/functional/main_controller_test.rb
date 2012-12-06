require 'test_helper'

class MainControllerTest < ActionController::TestCase
	test "should get board" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/board'
		assert_response :success, "Board does not exist or cannot be reached."
	end
	
	test "should get settings" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/settings'
		assert_response :success, "Settings does not exist or cannot be reached."
	end
	
	test "should get about" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/settings'
		assert_response :success, "About does not exist or cannot be reached."
	end

end
