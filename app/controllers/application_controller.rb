class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    @exception = exception
    render :file => 'public/403', :status => 403
  end
end
