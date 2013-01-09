# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CommComm::Application.initialize!

# Safety against a security exploit in parameter passing.
#  https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/61bkgvnSGTQ
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
