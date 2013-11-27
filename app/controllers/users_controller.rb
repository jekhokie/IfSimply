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

  def specify_paypal
    if user_signed_in?
      @user = User.find params[:id]
      authorize! :update, @user

      if params[:admin_page] and params[:admin_page].to_s == 'true'
        @admin_page = true
      end
    else
      render :template => "devise/sessions/new"
    end
  end

  def verify_paypal
    if user_signed_in?
      @user = User.find params[:id]
      authorize! :update, @user

      if (payment_email = params[:payment_email]).blank?
        flash[:error] = "You must specify a valid email address"
        render :specify_paypal
      else
        if PaypalProcessor.is_verified?(payment_email)
          current_user.payment_email = payment_email
          current_user.verified      = true
          current_user.save

          if params[:admin_page] and params[:admin_page].to_s == 'true'
            @club = @user.clubs.first
            render :template => 'admin/update_paypal'
          end
        else
          flash[:error] = "Email not verified - please visit PayPal to verify"
          render :specify_paypal
        end
      end
    else
      render :template => "devise/sessions/new"
    end

    flash.discard
  end
end
