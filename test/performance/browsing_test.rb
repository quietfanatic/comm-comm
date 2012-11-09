require 'test_helper'
require 'capybara/rails'

class BrowsingTest < ActiveSupport::TestCase
	include Capybara::DSL

	test "homepage should exist" do
		visit '/'
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

	test "topic should exist" do
		visit '/main/topic'
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end
   
	test "journey should exist" do
		visit '/login/journey'
		assert page.has_content?('Please fill out this form to request an invitation.') ||
			page.has_content?('Your journey is not yet complete.'),
			"This page does not have the correct content."
	end
   
	test "settings should exist" do
		visit '/main/settings'
		assert page.has_content?('Profile'), "This page does not have the correct content."
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
