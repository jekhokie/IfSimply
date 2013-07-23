class ClubsUsersController < ApplicationController
  before_filter :get_club

  def new
    if user_signed_in?
      @subscription = ClubsUsers.first{ |subscription| subscription.user == current_user and subscription.club == @club }
    end

    if @subscription.nil?
      @subscription      = ClubsUsers.new
      @subscription.club = @club
    end

    if user_signed_in?
      @subscription.user = current_user if @subscription.user.nil?
      session.delete(:subscription) unless session[:subscription].blank?
    else
      session[:subscription] = @subscription

      redirect_to new_user_registration_path
    end
  end

  def create
    if user_signed_in?
      if @club.members.include? current_user
        redirect_to club_path(@club)
      else
        @subscription       = ClubsUsers.new
        @subscription.club  = @club
        @subscription.user  = current_user
        @subscription.level = params[:level].blank? ? "" : params[:level].to_sym

        if @subscription.save
          redirect_to club_path(@club)
        else
          flash[:error] = "Invalid membership level specified"

          render :new
        end
      end
    else
      @sales_page = @club.sales_page
      redirect_to club_sales_page_path(@club)
    end
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
