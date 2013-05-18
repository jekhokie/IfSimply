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

  private

  def get_club
    @club = Club.find params[:id]
  end
end
