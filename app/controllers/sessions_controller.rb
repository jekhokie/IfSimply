class SessionsController < Devise::SessionsController
  protect_from_forgery :except => [ :create ]

  def new
  end

  protected

  def after_sign_in_path_for(resource)
    if session[:subscription]
      subscribe_to_club_path(session[:subscription].club)
    else
      super
    end
  end
end
