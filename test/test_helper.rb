ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
require 'carrierwave_helper'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def log_in_as(user, password: "foobar")
    post login_path, params: { name: user.name,
                            password: password }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_out
    delete logout_path
  end
end
