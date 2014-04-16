# Load the rails application
require File.expand_path('../application', __FILE__)

# Constant to be used in config/environments are defined here
SENDER_EMAIL_ = "info@snapby.co"

# Initialize the rails application
Snapby::Application.initialize!
