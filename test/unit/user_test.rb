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
		assert page.has_content?('Your request has been submitted.'), "This page is unreachable or does not have the correct content."
		assert !page.has_content?('Sorry, you must provide an email address.'), "Signup does not recognize that an email has been provided."
		assert !page.has_content?('Sorry, that email address wasn\'t accepted.'), "Signup is not accepting valid email addresses."
		assert !page.has_content?('Sorry, you must provide a name for yourself.'), "Signup does not recognize that a name has been provided."
		assert !page.has_content?('Sorry, you must provide a password.'), "Signup does not recognize that a password has been provided."
		assert !page.has_content?('Sorry, your password must be at least six characters long.'), "Signup is not accepting passwords of a valid length."
		assert !page.has_content?('Sorry, you must confirm your password.'), "Signup does not recognize that password confirmation has been provided."
		assert !page.has_content?('Sorry, your passwords didn\'t match.'), "Signup does not recognize that the password and password confirmation match."
		assert !page.has_content?('Sorry, that email address is in use.'), "Signup says that an email address is in use when this is not the case."
	end
	
	test "should give correct error when no email is provided during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, you must provide an email address.'), "Signup does not recognize that no email has been provided."
	end
	
	test "should give correct error when an invalid email is provided during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, that email address wasn\'t accepted.'), "Signup accepts emails with no \"@\" and no domain."
		fill_in 'email', :with => 'test@test.'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, that email address wasn\'t accepted.'), "Signup accepts emails with a \"@\" and a \".\" but no top-level domain."
		fill_in 'email', :with => '@.'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, that email address wasn\'t accepted.'), "Signup accepts emails with a \"@\" and a \".\" but no other characters."
	end
	
		test "should give correct error when no name is provided during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, you must provide a name for yourself.'), "Signup does not recognize that no name has been provided."
	end
	
	test "should give correct error when no password is provided during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, you must provide a password.'), "Signup does not recognize that no password has been provided."
	end
		
	test "should give correct error when the password provided during signup is too short" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdf'
		fill_in 'confirm_password', :with => 'asdf'
		click_on 'submit'
		assert page.has_content?('Sorry, your password must be at least six characters long.'), "Signup does not recognize that the password provided is too short."
	end
	
	test "should give correct error when no password confirmation is provided during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, you must confirm your password.'), "Signup does not recognize that no password confirmation has been provided."
	end
	
	test "should give correct error when the password and password confirmation do not match during signup" do
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf1'
		fill_in 'confirm_password', :with => 'asdfasdf2'
		click_on 'submit'
		assert page.has_content?('Sorry, your passwords didn\'t match.'), "Signup does not recognize that the password and password confirmation do not match."
	end
	
	test "should give correct error when the email provided during signup is already in use" do
		User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		visit '/login/entrance'
		click_on 'signup_tab'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'name', :with => 'test'
		fill_in 'password', :with => 'asdfasdf'
		fill_in 'confirm_password', :with => 'asdfasdf'
		click_on 'submit'
		assert page.has_content?('Sorry, that email address is in use.'), "Signup does not recognize that the provided email is already in use."
	end
	
	# test "should login without errors" do
		# visit '/'
		# User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		# fill_in 'email', :with => 'test@test.com'
		# fill_in 'password', :with => 'asdfasdfasdf'
		# click_on 'enter'
		# assert page.has_content?('Uncategorized'), "This page is unreachable or does not have the correct content."
		# visit '/main/topic'
		# fill_in 'content', :with => 'test post'
		# click_on 'submit'
	# end
end
