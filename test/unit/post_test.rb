require 'test_helper'
require 'capybara/rails'
require 'selenium/rspec/spec_helper'

class PostTest < ActiveSupport::TestCase
	include Capybara::DSL
	include Selenium
	Capybara.javascript_driver = :selenium
	
	test "new should exist" do
		visit '/main/topic'
		#post '/post/new'
		#fill_in 'content', :with => 'Test Content'
		click_on 'submit'
		assert page.has_content?('Comm-Comm'), "This page does not have the correct content."
	end

end
