class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def internal_network?
    if Rails.env.production?
      super
    else
      request.host == '172.31.225.21'
    end
  end

end
