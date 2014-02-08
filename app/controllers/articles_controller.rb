class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club,    :only => [ :create, :show_all ]
  before_filter :get_article, :only => [ :show, :edit, :update ]

  def show
    redirect_to club_sales_page_path(@article.club) and return unless (user_signed_in? and can?(:read, @article))

    if request.path != article_path(@article)
      redirect_to article_path(@article), status: :moved_permanently and return
    end
  end

  def edit
    authorize! :edit, @article
    @club = @article.club

    if request.path != article_path(@article)
      render article_editor_path(@article), :text => "", :status => :moved_permanently, :layout => "mercury" and return
    end
  end

  def create
    @article = @club.articles.new

    authorize! :create, @article

    @article.assign_defaults
    @article.save

    redirect_to article_editor_path(@article)
  end

  def update
    authorize! :update, @article

    if params[:article] and params[:article][:free]
      @article.free = params[:article][:free]
    else
      article_hash     = params[:content]
      @article.title   = article_hash[:article_title][:value]
      @article.content = article_hash[:article_content][:value]
      @article.image   = article_hash[:article_image][:attributes][:src]
    end

    if @article.save
      render :text => ""
    else
      respond_error_to_mercury [ @article ]
    end
  end

  def show_all
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)

    @articles = @club.articles
  end

  def destroy
    article = Article.find params[:id]
    @club   = article.club

    authorize! :destroy, article

    flash[:error] = "An error occurred destroying the Article" unless article.destroy

    redirect_to show_all_club_articles_path(@club)

    flash.discard
  end

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_article
    @article = Article.find params[:id]
  end
end
