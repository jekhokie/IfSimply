class SalesPagesController < ApplicationController
  def show
    @club       = Club.find params[:club_id]
    @sales_page = @club.sales_page

    authorize! :read, @sales_page
  end
end
