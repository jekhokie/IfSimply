class UsersController < ApplicationController
  def edit
    if user_signed_in?
      @user = current_user
      authorize! :update, @user
    else
      redirect_to new_user_session_path
    end
  end

  def update
    if user_signed_in?
      @user = current_user
      authorize! :update, @user

      @user.update_attributes params[:user]

      respond_with_bip @user
    else
      redirect_to new_user_session_path
    end
  end

  def change_icon
    if user_signed_in?
      @user = current_user
      authorize! :update, @user
    else
      redirect_to new_user_session_path
    end
  end

  def upload_icon
    if user_signed_in?
      @user = current_user
      authorize! :update, @user

      # if no user icon was specified
      if params[:user].blank?
        render :change_icon, :formats => [ :js ]
      elsif @user.update_attributes params[:user]
        render
      else
        render :change_icon, :formats => [ :js ]
      end
    else
      redirect_to new_user_session_path
    end
  end
end
