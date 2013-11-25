class ConfirmationsController < Devise::ConfirmationsController
  def show
    user = User.find_by_confirmation_token params[:confirmation_token]

    # assign defaults
    unless user.blank?
      user.description = Settings.users[:default_description] if user.description.blank?
      user.icon        = Settings.users[:default_icon] if user.icon.blank?

      user.save
    end

    super
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    user_editor_path(resource)
  end
end
