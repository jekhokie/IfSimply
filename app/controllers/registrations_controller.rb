class RegistrationsController < Devise::RegistrationsController
  def new
  end

  def create
    @user = User.new params[:user]

    if params[:policy_agree] and params[:policy_agree] == 'true'
      if @user.valid?
        super
      end
    else
      flash[:alert] = "You must agree to the Terms of Service"
    end

    flash.discard
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    registration_notify_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
