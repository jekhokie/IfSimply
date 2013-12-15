class PasswordsController < Devise::PasswordsController
  def new
    super
  end

  def create
    if params[:user] and params[:user][:email] and User.where(:email => params[:user][:email]).first.blank?
      flash[:alert] = "Email is not in the system"
    else
      super
    end

    flash.discard
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    after_devise_path
  end
end
