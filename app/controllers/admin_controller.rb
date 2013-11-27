class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_club

  def show
    authorize! :update, @club
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
