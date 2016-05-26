ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'mocha/mini_test'
require 'database_cleaner'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

DatabaseCleaner.strategy = :transaction

module ControllerHelpers
  def sign_in(user)
    request.env['warden'].stubs(:authenticate!).returns(user)
    @controller.stubs(:current_user).returns(user)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
  include ControllerHelpers
  include FactoryGirl::Syntax::Methods
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end
