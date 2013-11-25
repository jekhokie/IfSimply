class SalesPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club_and_sales_page

  def show
    unless can?(:read, @sales_page)
      flash[:error] = "Club Owner is not verified - please let them know they need to verify their account!"

      redirect_to root_path
    end
  end

  def edit
    authorize! :update, @sales_page

    render :text => '', :layout => "mercury"
  end

  def update
    authorize! :update, @sales_page

    sales_page_hash            = params[:content]
    @sales_page.heading        = sales_page_hash[:sales_page_heading][:value]
    @sales_page.sub_heading    = sales_page_hash[:sales_page_sub_heading][:value]
    @sales_page.video          = sales_page_hash[:sales_page_video_url][:value]
    @sales_page.call_to_action = sales_page_hash[:sales_page_call_to_action][:value]
    @sales_page.call_details   = sales_page_hash[:sales_page_call_details][:value]
    @sales_page.benefit1       = sales_page_hash[:sales_page_benefit1][:value]
    @sales_page.benefit2       = sales_page_hash[:sales_page_benefit2][:value]
    @sales_page.benefit3       = sales_page_hash[:sales_page_benefit3][:value]
    @sales_page.details        = sales_page_hash[:sales_page_details][:value]

    if @sales_page.save
      render :text => ""
    else
      respond_error_to_mercury [ @sales_page ]
    end
  end

  private

  def get_club_and_sales_page
    @club       = Club.find params[:club_id]
    @sales_page = @club.sales_page
  end
end
