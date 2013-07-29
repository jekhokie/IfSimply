class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    @violation = exception
    render :template => 'home/access_violation', :status => 403
  end

  def respond_error_to_mercury(resource)
    response.headers["X-Flash-Error"] = resource.errors.full_messages.join("\n")
    render :text => "error", :status => 422
  end
end
