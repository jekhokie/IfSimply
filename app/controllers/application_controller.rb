class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :is_editing?

  rescue_from CanCan::AccessDenied do |exception|
    @violation = exception
    render :template => 'home/access_violation', :status => 403
  end

  def respond_error_to_mercury(resources)
    errors_string = ""

    resources.each do |resource|
      errors_string += resource.errors.full_messages.join("\n")
    end

    response.headers["X-Flash-Error"] = errors_string
    render :text => "error", :status => 422
  end

  private

  def is_editing?
    params[:mercury_frame].blank? ? false : true
  end
end
