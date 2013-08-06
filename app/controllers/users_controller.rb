class UsersController < ApplicationController
  def show
    @user = User.find params[:id]

    redirect_to new_user_session_path unless user_signed_in? and can?(:read, @user)
  end

  def edit
    if user_signed_in?
      @user = User.find params[:id]
      authorize! :update, @user

      render :text => '', :layout => "mercury"
    else
      redirect_to new_user_session_path
    end
  end

  def update
    if user_signed_in?
      @user = User.find params[:id]
      authorize! :update, @user

      user_hash         = params[:content]
      @user.description = user_hash[:user_description][:value]
      @user.icon        = user_hash[:user_icon][:attributes][:src]

      if @user.save
        render :text => ""
      else
        respond_error_to_mercury [ @user ]
      end
    else
      redirect_to new_user_session_path
    end
  end
end
