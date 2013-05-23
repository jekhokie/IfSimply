class DiscussionBoardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_discussion_board, :only => [ :edit, :update ]

  def edit
    authorize! :edit, @discussion_board

    @club = @discussion_board.club
  end

  def update
    authorize! :update, @discussion_board

    @discussion_board.update_attributes params[:discussion_board]

    respond_with_bip @discussion_board
  end

  private

  def get_discussion_board
    @discussion_board = DiscussionBoard.find params[:id]
  end
end
