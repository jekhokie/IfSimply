class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :get_discussion_board, :only => [ :new, :create ]

  def new
    @topic = @discussion_board.topics.new

    authorize! :create, @topic
  end

  def create
    @topic = @discussion_board.topics.new params[:topic]

    authorize! :create, @topic

    if @topic.save
      flash[:notice] = "Topic posted successfully"

      if can?(:update, @discussion_board.club)
        redirect_to edit_discussion_board_path(@discussion_board)
      else
        redirect_to discussion_board_path(@discussion_board)
      end
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
