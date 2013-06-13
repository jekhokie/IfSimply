class SalesPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]

  def show
    @club       = Club.find params[:club_id]
    @sales_page = @club.sales_page

    authorize! :read, @sales_page
  end

  def edit
    @sales_page = SalesPage.find params[:id]
    @club       = @sales_page.club

    authorize! :update, @sales_page
  end
end
