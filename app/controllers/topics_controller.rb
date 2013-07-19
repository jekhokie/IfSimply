class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_discussion_board, :only => [ :new, :create ]

  def new
    authorize! :update, @discussion_board

    @topic = @discussion_board.topics.new
  end

  def create
    authorize! :update, @discussion_board

    @topic = @discussion_board.topics.new params[:topic]

    if @topic.save
      flash[:notice] = "Topic posted successfully"
      redirect_to edit_discussion_board_path(@discussion_board)
    else
      render :new
    end

    flash.discard
  end

  def show
    @topic = Topic.find params[:id]

    redirect_to club_sales_page_path(@topic.club) unless user_signed_in? and can?(:read, @topic)
  end

  private

  def get_discussion_board
    @discussion_board = DiscussionBoard.find params[:discussion_board_id]
  end
end
