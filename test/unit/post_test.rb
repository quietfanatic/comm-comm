require 'test_helper'

class PostTest < ActionDispatch::IntegrationTest
	setup do
		Capybara.current_driver = Capybara.javascript_driver
	end
	
	test "should create new posts" do
		user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		user.session = 1
		user.save!
		cookies['_comm_comm_session'] = 1
		page.set_rack_session(:session_id => 1, :user_id => user.id)
		visit '/login/entrance'
		fill_in 'email', :with => 'test@test.com'
		fill_in 'password', :with => 'asdfasdf'
		click_on 'enter'
		assert page.has_content?('Comm Comm'), "This page does not have the correct content."
		fill_in 'new_post_content', :with => 'Test Post'
		click_on 'new_post_submit'
		assert page.has_content?('Test Post'), "Posting did not work."
	end
	
	# test "should hide posts" do
		# Capybara.current_driver = :webkit
		# user = User.create(:email => 'test@test.com', :username => 'test', :password => 'asdfasdf', :is_confirmed => true)
		# user.session = 1
		# user.save!
		# cookies['_comm_comm_session'] = 1
		# page.set_rack_session(:session_id => 1, :user_id => user.id)
		# visit '/login/entrance'
		# fill_in 'email', :with => 'test@test.com'
		# fill_in 'password', :with => 'asdfasdf'
		# click_on 'enter'
		# visit '/main/board'
		# post = Post.find(1)
		# assert page.has_content?(post.content), "The post isn't there in the first place."
		# click_on 'hide_button_1'
		# assert !page.has_content?(post.content), "Hiding the post didn't work."
	# end
end