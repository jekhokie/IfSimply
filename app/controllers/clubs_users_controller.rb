class ClubsUsersController < ApplicationController
  def new
    @club = Club.find params[:id]

    @subscription         = ClubsUsers.new
    @subscription.club_id = @club.id

    if user_signed_in?
      @subscription.user_id = current_user.id
      session.delete(:subscription) unless session[:subscription].blank?
    else
      session[:subscription] = @subscription

      redirect_to new_user_registration_path
    end
  end
end
