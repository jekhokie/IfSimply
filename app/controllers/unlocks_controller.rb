class UnlocksController < Devise::UnlocksController
  def new
    super
  end

  def create
    if params[:user] and params[:user][:email] and (user = User.where(:email => params[:user][:email]).first).blank?
      flash[:alert] = "Email is not in the system"
    elsif ! user.locked_at?
      flash[:alert] = "Account is not locked - please try signing in"
    else
      super
    end

    flash.discard
  end

  protected

  def after_sending_unlock_instructions_path_for(resource)
    after_devise_path
  end

  def after_unlock_path_for(resource)
    root_path
  end
end
