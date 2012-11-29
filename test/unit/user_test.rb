require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "should create new users without errors" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Your request has been submitted.'), "This page does not have the correct content."
		assert !page.has_content?('Sorry, you must provide an email address.')
		assert !page.has_content?('Sorry, that email address wasn\'t accepted.')
		assert !page.has_content?('Sorry, you must provide a name for yourself.')
		assert !page.has_content?('Sorry, you must provide a password.')
		assert !page.has_content?('Sorry, your password must be at least six characters long.')
		assert !page.has_content?('Sorry, you must confirm your password.')
		assert !page.has_content?('Sorry, your passwords didn\'t match.')
		assert !page.has_content?('Sorry, that email address is in use.')
	end
	
	test "should login without errors" do
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
