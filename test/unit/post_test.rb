require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "should create new users" do
		visit '/login/entrance'
		click_on 'request'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdf'
		fill_in 'confirm_password', :with => 'asdf'
		click_on 'submit'
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

end