require 'test_helper'
require 'capybara/rails'

class PostTest < ActiveSupport::TestCase
	include Capybara::DSL
	
	test "main should exist" do
     visit '/main/topic'
	 assert page.has_content?('Comm-Comm')
   end
end
