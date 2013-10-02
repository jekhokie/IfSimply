class PaypalTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def preapproval
    @club = Club.find params[:club_id]

    # attempt to get the subscription of the user (handle bogus requests)
    begin
      subscription = current_user.subscriptions.select{ |subscription| subscription.club_id == @club.id }.first
    rescue
    end

    # check that the user has a subscription, a xuuid is passed and
    # the xuuid matches the preapproval_uuid in the subscription
    if subscription.blank? or params[:xuuid].blank? or params[:xuuid].to_s != subscription.preapproval_uuid
      @sales_page = @club.sales_page

      redirect_to club_sales_page_path(@club)
    else
      subscription.pro_status       = "ACTIVE"
      subscription.anniversary_date = Date.today + Settings.paypal[:free_days].days
      subscription.save

      redirect_to @club
    end
  end
end
