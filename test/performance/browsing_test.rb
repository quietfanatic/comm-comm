require 'test_helper'
require 'capybara/rails'

class BrowsingTest < ActiveSupport::TestCase
	include Capybara::DSL

	test "homepage should exist" do
		visit '/'
		assert page.has_content?('Comm Comm'), "This page does not have the correct content."
	end  
	
	test "journey should exist" do
		visit '/login/journey'
		assert page.has_content?('Please fill out this form to request an invitation.') ||
			page.has_content?('Your journey is not yet complete.'),
			"This page does not have the correct content."
	end
	
	test "entrance should exist" do
		visit '/login/entrance'
		assert page.has_content?('Please log in to use this site.'), "This page does not have the correct content."
	end
	
	test "signup should exist" do
		visit '/login/signup'
		assert page.has_content?('Please fill out this form to request an invitation.'), "This page does not have the correct content."
	end	
end
	
	test "board should exist" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/board'
		assert page.has_content?('Uncategorized'), "This page does not have the correct content."
	end
	
	test "settings should exist" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/settings'
		assert page.has_content?('Profile'), "This page does not have the correct content."
	end
	
	test "about should exist" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/main/about'
		assert page.has_content?('About Us'), "This page does not have the correct content."
	end
