require 'test_helper'

class BrowsingTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver
	end

	test "homepage should exist and have the correct content" do
		visit '/'
		assert page.has_content?('Comm Comm'), "This page does not have the correct content."
	end  
	
	test "journey should exist and have the correct content" do
		visit '/login/journey'
		assert page.has_content?('Please fill out this form to request an invitation.') ||
			page.has_content?('Your journey is not yet complete.'),
			"This page does not have the correct content."
	end
	
	test "entrance should exist and have the correct content" do
		visit '/login/entrance'
		assert page.has_content?('Please log in to use this site.'), "This page does not have the correct content."
	end
	
	test "signup should exist and have the correct content" do
		visit '/login/signup'
		assert page.has_content?('Please fill out this form to request an invitation.'), "This page does not have the correct content."
	end
	
	test "board should exist and have the correct content" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/login/entrance'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		visit '/main/board'
		assert page.has_content?('Uncategorized'), "This page does not have the correct content."
	end
	
	test "settings should exist and have the correct content" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/login/entrance'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		visit '/main/settings'
		assert page.has_content?('Profile'), "This page does not have the correct content."
		assert page.has_content?('Sessions'), "This page does not have the correct content."
	end
	
	test "about should exist and have the correct content" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/login/entrance'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		visit '/main/about'
		assert page.has_content?('About Us'), "This page does not have the correct content."
		assert page.has_content?('About the Community Communicator'), "This page does not have the correct content."
	end
end
