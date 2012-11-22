require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "should create new users" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		visit 'main/board'
		assert page.has_content?('Comm Comm'), "This page does not have the correct content."
	end
end