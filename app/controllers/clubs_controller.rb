class ClubsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :get_club

  def edit
    authorize! :update, @club
  end

  def update
    authorize! :update, @club

    @club.update_attributes params[:club]

    respond_with_bip @club
  end

  def change_logo
    authorize! :update, @club
  end

  def upload_logo
    authorize! :update, @club

    if @club.update_attributes params[:club]
      redirect_to edit_club_path(@club)
    else
      render :change_logo, :formats => [ :js ]
    end
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
