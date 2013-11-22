class UpsellPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club_and_upsell_page

  def show
    unless can?(:read, @upsell_page)
      flash[:error] = "Club Owner is not verified - please let them know they need to verify their account!"

      redirect_to root_path
    end
  end

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
