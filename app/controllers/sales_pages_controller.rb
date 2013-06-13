class SalesPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club_and_sales_page, :only => [ :edit, :update ]

  def show
    @club       = Club.find params[:club_id]
    @sales_page = @club.sales_page

    authorize! :read, @sales_page
  end

  def edit
    authorize! :update, @sales_page
  end

  def update
    authorize! :update, @sales_page

    @sales_page.update_attributes params[:sales_page]

    respond_with_bip @sales_page
  end

  private

  def get_club_and_sales_page
    @sales_page = SalesPage.find params[:id]
    @club       = @sales_page.club
  end
end
