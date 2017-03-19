ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  def http_login(headers = {})
    begin
      user = User.find_by(email: 'foo@example.com')
    rescue
      user = User.create!(email: 'foo@example.com', password: 'foo', password_confirmation: 'foo')
    end
    headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
    headers
  end
end
