class SalesPagesController < ApplicationController
  def show
    @sales_page = SalesPage.find params[:id]
    @club       = @sales_page.club

    authorize! :read, @sales_page
  end
end
