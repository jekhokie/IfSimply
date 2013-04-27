class ClubsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @club = Club.find params[:id]

    authorize! :manage, @club
  end
end
