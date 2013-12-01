class ConfirmationsController < Devise::ConfirmationsController
  def show
    user = User.find_by_confirmation_token params[:confirmation_token]

    # assign defaults
    unless user.blank?
      user.description = Settings.users[:default_description] if user.description.blank?
      user.icon        = Settings.users[:default_icon] if user.icon.blank?

      user.save

      # send a thank-you for signing up email
      AccountMailer.delay.sign_up_thank_you(user, request.protocol, request.host_with_port)
    end

    super
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    user_editor_path(resource)
  end
end
