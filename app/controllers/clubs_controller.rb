class ClubsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club

  def show
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)
  end

  def edit
    authorize! :update, @club

    render :text => '', :layout => "mercury"
  end

  def update
    authorize! :update, @club

    club_hash         = params[:content]
    @club.name        = club_hash[:club_name][:value]
    @club.sub_heading = club_hash[:club_sub_heading][:value]
    @club.description = club_hash[:club_description][:value]
    @club.logo        = club_hash[:club_logo][:attributes][:src]

    if @club.save
      render :text => ""
    else
      respond_error_to_mercury @club
    end
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
