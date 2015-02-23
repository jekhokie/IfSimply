class ClubsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :specify_price, :update_price, :subscribers ]
  before_filter :get_club

  def show
    redirect_to club_sales_page_path(@club) and return unless (user_signed_in? and can?(:read, @club))

    if request.path != club_path(@club)
      redirect_to @club, status: :moved_permanently and return
    end
  end

  def edit
    authorize! :update, @club

    if request.path != club_path(@club)
      render club_editor_path(@club), :text => "", :status => :moved_permanently, :layout => "mercury" and return
    end
  end

  def update
    authorize! :update, @club

    club_hash                 = params[:content]
    @club.name                = club_hash[:club_name][:value]
    @club.sub_heading         = club_hash[:club_sub_heading][:value]
    @club.description         = club_hash[:club_description][:value]
    @club.courses_heading     = club_hash[:club_courses_heading][:value]
    @club.articles_heading    = club_hash[:club_articles_heading][:value]
    @club.discussions_heading = club_hash[:club_discussions_heading][:value]
    @club.logo                = club_hash[:club_logo][:attributes][:src]

    if @club.save
      render :text => ""
    else
      respond_error_to_mercury [ @club ]
    end
  end

  def update_free_content
    authorize! :update, @club

    @club.free_content = params[:club][:free_content]

    if @club.save
      render :text => ""
    else
      respond_error_to_mercury [ @club ]
    end

    flash.discard
  end

  def specify_price
    if user_signed_in?
      authorize! :update, @club
    else
      render :template => "devise/sessions/new"
    end
  end

  def update_price
    if user_signed_in?
      authorize! :update, @club

      if (club_price = params[:club_price]).blank?
        flash[:error] = "You must specify a valid club price"
        render :specify_price
      else
        @club.price = club_price

        unless @club.save
          flash[:error] = @club.errors.full_messages.first
          @club.reload
          render :specify_price
        end
      end
    else
      render :template => "devise/sessions/new"
    end

    flash.discard
  end

  def subscribers
    if user_signed_in?
      authorize! :update, @club

      @basic_subscriptions = @club.subscriptions.where(:level => "basic")
      @pro_subscriptions   = @club.subscriptions.where("level = 'pro' and pro_status != 'INACTIVE'")
    else
      render :template => "devise/sessions/new"
    end
  end

  def export_subscribers
    authorize! :update, @club

    # formulate the CSV data
    csv_data = ""
    if (csv_type = params[:csv_type])
      csv_data = case(csv_type.to_s)
                 when "all"
                   @club.all_members_to_csv
                 when "basic"
                   @club.basic_members_to_csv
                 when "pro"
                   @club.pro_members_to_csv
                 end
    end

    send_data(csv_data, :type => "text/csv", :disposition => "attachment; filename=#{csv_type.capitalize}_Members.csv")
  end

  private

  def get_club
    @club = Club.find params[:id]
  end
end
