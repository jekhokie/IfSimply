class RegistrationsController < Devise::RegistrationsController
  def new
  end

  def create
    @user = User.new params[:user]

    if @user.valid?
      super
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    registration_notify_path
  end
end
