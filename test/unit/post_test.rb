require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	
	test "new should exist" do
		visit '/main/topic'
		#fill_in 'content', :with => 'Test Content'
		find('new_post_submit').click
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

end