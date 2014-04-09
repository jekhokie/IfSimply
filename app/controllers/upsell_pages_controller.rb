class UpsellPagesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_club_and_upsell_page

  def show
    @subscription = @club.subscriptions.find_by_user_id(current_user.id) if user_signed_in?

    if !can?(:read, @upsell_page)
      flash[:error] = "Club Owner is not verified - please let them know they need to verify their account!"
      redirect_to root_path
    elsif ! @upsell_page.club.free_content
      flash[:error] = "This club does not allow basic memberships - please subscribe through the sales page."
      redirect_to root_path
    end
  end

  def edit
    authorize! :update, @upsell_page

    if @upsell_page.club.free_content
      render :text => '', :layout => "mercury"
    else
      flash[:error] = "You elected no free content, meaning there is no need for an upsell page. Please check your account page."
      redirect_to club_editor_path(@upsell_page.club)
    end
  end

  def update
    authorize! :update, @upsell_page

    upsell_page_hash                     = params[:content]
    @upsell_page.heading                 = upsell_page_hash[:upsell_page_heading][:value]
    @upsell_page.sub_heading             = upsell_page_hash[:upsell_page_sub_heading][:value]
    @upsell_page.basic_articles_desc     = upsell_page_hash[:upsell_page_basic_articles_desc][:value]
    @upsell_page.exclusive_articles_desc = upsell_page_hash[:upsell_page_exclusive_articles_desc][:value]
    @upsell_page.basic_courses_desc      = upsell_page_hash[:upsell_page_basic_courses_desc][:value]
    @upsell_page.in_depth_courses_desc   = upsell_page_hash[:upsell_page_in_depth_courses_desc][:value]
    @upsell_page.discussion_forums_desc  = upsell_page_hash[:upsell_page_discussion_forums_desc][:value]

    @club.price = upsell_page_hash[:club_price][:value]

    if @upsell_page.save and @club.save
      render :text => ""
    else
      respond_error_to_mercury [ @upsell_page, @club ]
    end
  end

  private

  def get_club_and_upsell_page
    @club        = Club.find params[:club_id]
    @upsell_page = @club.upsell_page
  end
end
