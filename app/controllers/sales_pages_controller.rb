class SalesPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club_and_sales_page

  def show
    authorize! :read, @sales_page
  end

  def edit
    authorize! :update, @sales_page
  end

  private

  def get_club_and_sales_page
    @club       = Club.find params[:club_id]
    @sales_page = @club.sales_page
  end
end
