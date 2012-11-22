require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "should create new users" do
		visit '/login/entrance'
		click_on 'request'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdf'
		fill_in 'confirm_password', :with => 'asdf'
		click_on 'submit'
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end
	
	test "should login" do
		visit '/'
		User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		assert page.has_content?('Uncategorized'), "This page does not have the correct content."
		visit '/main/topic'
		fill_in 'content', :with => 'test post'
		click_on 'submit'
	end
end
