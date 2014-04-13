class SessionsController < Devise::SessionsController
  protect_from_forgery :except => [ :create ]

  def new
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    # redirect user using HTML if non-JS sign-in
    if session[:subscription]
      respond_with resource, :location => subscribe_to_club_path(session[:subscription].club) and return
    elsif session["user_return_to"]
      render :js => "window.location = '#{session["user_return_to"]}'" and return if session["user_return_to"]
    else
      super
    end
  end
end
