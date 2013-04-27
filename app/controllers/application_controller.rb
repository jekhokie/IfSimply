class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    @exception = exception
    render :template => 'home/access_violation', :status => 403
  end
end
