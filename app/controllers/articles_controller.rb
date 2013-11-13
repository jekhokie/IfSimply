class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club,    :only => [ :create, :show_all ]
  before_filter :get_article, :only => [ :show, :edit, :update ]

  def show
    redirect_to club_sales_page_path(@article.club) unless user_signed_in? and can?(:read, @article)
  end

  def create
    @article = @club.articles.new

    authorize! :create, @article

    @article.assign_defaults
    @article.save

    redirect_to article_editor_path(@article)
  end

  def edit
    authorize! :edit, @article
    @club = @article.club

    render :text => '', :layout => "mercury"
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

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_article
    @article = Article.find params[:id]
  end
end
