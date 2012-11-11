require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver # :selenium by default
	end
	
	test "login should work" do
		visit '/login/entrance'
		#fill_in 'content', :with => 'Test Content'
		find_element(:id, 'new_post_submit').click
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

end