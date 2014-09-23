require 'securerandom'

class ClubsUsersController < ApplicationController
  before_filter :get_club, :except => [ :destroy ]

  def new
    if user_signed_in? and current_user != @club.user
      @subscription = ClubsUsers.where(:user_id => current_user.id, :club_id => @club.id).first
    end

    if @subscription.nil? and !(user_signed_in? and current_user == @club.user)
      @subscription      = ClubsUsers.new
      @subscription.club = @club
    end

    # map the subscribe path based on logged in/not logged in/same user
    if user_signed_in?
      if current_user == @club.user
        @subscribe_button_path = ''
      else
        @subscribe_button_path = add_member_to_club_path(@club)
      end
    else
      @subscribe_button_path = subscribe_to_club_path(@club)
    end

    if user_signed_in?
      if current_user == @club.user
        render :js => "window.location = '#{upsell_page_editor_path(@club)}'" and return
      else
        @subscription.user = current_user if @subscription.user.nil?
        session.delete(:subscription) unless session[:subscription].blank?

        respond_to do |format|
          format.html do
            if @club.free_content
              redirect_to club_upsell_page_path(@club)
            else
              redirect_to add_member_to_club_path(@club, :level => 'pro')
            end
          end
          format.js do
            if @club.free_content
              render :js => "window.location = '#{club_upsell_page_path(@club)}'"
            else
              render :js => "window.location = '#{add_member_to_club_path(@club, :level => 'pro')}'"
            end
          end
        end
      end
    else
      session[:subscription] = @subscription

      render :template => "devise/sessions/new", :formats => [ :js ], :handlers => [ :coffee ] and return
    end
  end

  def create
    if user_signed_in?
      if current_user != @club.user
        existing_membership = @club.subscriptions.find_by_user_id(current_user.id)
        requested_level     = params[:level].blank? ? "" : params[:level].to_s

        if ! @club.free_content and requested_level == 'basic'
          redirect_to root_path, :alert => "This club does not allow basic memberships."
        else
          if existing_membership                           and
             existing_membership.level  == requested_level and
             (existing_membership.level == 'basic' or existing_membership.pro_status == "ACTIVE")
            redirect_to club_path(@club)
          else
            if existing_membership
              @subscription = existing_membership
            else
              @subscription       = ClubsUsers.new
              @subscription.level = requested_level
              @subscription.club  = @club
              @subscription.user  = current_user
            end

            if requested_level == 'pro'
              # generate the root URL
              prefix = "#{Settings.general['protocol']}://#{Settings.general['host']}:#{Settings.general['port']}"

              # determine if we need a trial period or not
              start_date = DateTime.now + Settings.paypal[:free_days].days
              if existing_membership and existing_membership.anniversary_date
                if existing_membership.anniversary_date < Date.today
                  start_date = DateTime.now
                else
                  start_date = existing_membership.anniversary_date
                end
              end

              end_date = start_date + 1.year

              @subscription.preapproval_uuid = SecureRandom.uuid
              preapproval_hash = PaypalProcessor.request_preapproval(@club.price.dollars,
                                                                     "%.2f" % (@club.price.dollars * 12),
                                                                     "#{prefix}#{subscribe_to_club_path(@club)}",
                                                                     "#{prefix}/adaptive_payments/preapproval?club_id=#{@club.id}&xuuid=#{@subscription.preapproval_uuid}",
                                                                     current_user.name,
                                                                     @club.name,
                                                                     start_date,
                                                                     end_date)

              if preapproval_hash.blank?
                flash[:error] = "Unexpected behavior from PayPal - Please check back later"
                render :new
              else
                @subscription.preapproval_key = preapproval_hash[:preapproval_key]
                @subscription.pro_status = (existing_membership ? "PRO_CHANGE" : "FAILED_PREAPPROVAL")
                @subscription.save

                redirect_to preapproval_hash[:preapproval_url]
              end
            else
              @subscription.level      = requested_level
              @subscription.pro_status = 'INACTIVE'

              if @subscription.save
                redirect_to club_path(@club)
              else
                flash[:error] = "Invalid membership level specified"
                render :new
              end
            end
          end
        end
      else
        redirect_to club_editor_path(@club)
      end
    else
      @sales_page = @club.sales_page
      redirect_to club_sales_page_path(@club)
    end
  end

  def destroy
    subscription = ClubsUsers.find params[:id]

    authorize! :destroy, subscription

    if subscription.level == "pro"
      subscription.pro_status = "INACTIVE"
      subscription.save
    else
      subscription.destroy
    end

    redirect_to user_editor_path(current_user)
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
