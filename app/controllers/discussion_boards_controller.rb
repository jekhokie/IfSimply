class DiscussionBoardsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_discussion_board, :only => [ :show, :edit, :update ]
  before_filter :get_club, :only => [ :show, :edit ]

  def show
    redirect_to club_sales_page_path(@discussion_board.club) unless user_signed_in? and can?(:read, @discussion_board)
  end

  def edit
    authorize! :edit, @discussion_board

    render :text => '', :layout => "mercury"
  end

  def update
    authorize! :update, @discussion_board

    discussion_board_hash         = params[:content]
    @discussion_board.name        = discussion_board_hash[:discussion_board_name][:value]
    @discussion_board.description = discussion_board_hash[:discussion_board_description][:value]

    if @discussion_board.save
      render :text => ""
    else
      respond_error_to_mercury [ @discussion_board ]
    end
  end

  private

  def get_discussion_board
    @discussion_board = DiscussionBoard.find params[:id]
  end

  def get_club
    @club = @discussion_board.club
  end
end
