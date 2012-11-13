# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CommComm::Application.initialize!

require 'yaml'
local_config_file = "config/local.yml"

if File.exist? local_config_file
  local_config = YAML.load_file(local_config_file)
else
  local_config = {}
end

