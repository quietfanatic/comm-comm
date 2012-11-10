require 'test_helper'
require 'capybara/rails'
require 'selenium-webdriver'

class PostTest < ActiveSupport::TestCase
	include Capybara::DSL
	include Selenium
	Capybara.javascript_driver = :selenium
	
	test "new should exist" do
		visit '/main/topic'
		#fill_in 'content', :with => 'Test Content'
		find('tubmit#new_post_submit').click
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

end