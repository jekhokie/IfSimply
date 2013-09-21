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
      existing_membership = @club.subscriptions.find_by_user_id(current_user.id)
      requested_level     = params[:level].blank? ? "" : params[:level].to_sym

      if existing_membership and existing_membership.level.to_s == requested_level.to_s and
         (existing_membership.level == 'basic' or existing_membership.pro_active == true)
        redirect_to club_path(@club)
      else
        @subscription       = ClubsUsers.new
        @subscription.club  = @club
        @subscription.user  = current_user
        @subscription.level = requested_level

        if params[:level].to_sym == :pro
          # generate the root URL
          prefix = "#{Settings.general['protocol']}://#{Settings.general['host']}:#{Settings.general['port']}"

          preapproval_hash = PaypalProcessor.request_preapproval(@club.price.dollars,
                                                                 "#{prefix}#{subscribe_to_club_path(@club)}",
                                                                 "#{prefix}/adaptive_payments/preapproval?club_id=#{@club.id}",
                                                                 current_user.name,
                                                                 @club.name)

          if preapproval_hash.blank?
            flash[:error] = "Unexpected behavior from PayPal - Please check back later"
            render :new
          else
            @subscription.preapproval_key = preapproval_hash[:preapproval_key]
            @subscription.pro_active      = false
            @subscription.save

            redirect_to preapproval_hash[:preapproval_url]
          end
        else
          if @subscription.save
            redirect_to club_path(@club)
          else
            flash[:error] = "Invalid membership level specified"
            render :new
          end
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
