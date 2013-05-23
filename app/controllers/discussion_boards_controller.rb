class DiscussionBoardsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @discussion_board = DiscussionBoard.find params[:id]

    authorize! :edit, @discussion_board

    @club = @discussion_board.club
  end
end
