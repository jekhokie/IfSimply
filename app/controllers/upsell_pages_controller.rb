class UpsellPagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_club_and_upsell_page, :only => [ :edit, :update ]

  def edit
    authorize! :update, @upsell_page

    render :text => '', :layout => "mercury"
  end

  private

  def get_club_and_upsell_page
    @club        = Club.find params[:club_id]
    @upsell_page = @club.upsell_page
  end
end
