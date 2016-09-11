class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def auth_as_admin
    if ENV['ENABLE_AUTH']
      authenticate_or_request_with_http_basic do |user, pass|
      # TODO: temporary impls
        user == ENV['ADMIN_USER'] && pass == ENV['ADMIN_PASS']

        end
    else
      true
    end
  end
end
