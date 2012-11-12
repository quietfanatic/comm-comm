require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "should browse site" do
		visit '/login/entrance'
		click_on 'request'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Your request has been submitted.'), "This page does not have the correct content."
		User.find_by_email('test@test.com').update_attributes(:is_confirmed => true)
		visit '/login/entrance'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		assert page.has_content?('Uncategorized'), "This page does not have the correct content."
		fill_in 'new_post_content', :with => 'test post'
		click_on 'new_post_submit'
	end
	
end