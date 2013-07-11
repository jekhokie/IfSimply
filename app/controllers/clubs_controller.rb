class ClubsController < ApplicationController
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

    # if no club logo was specified
    if params[:club].blank?
      render :change_logo, :formats => [ :js ]
    elsif @club.update_attributes params[:club]
      render
    else
      render :change_logo, :formats => [ :js ]
    end
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
