# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController

  # for right method article_path here in controller
#  include ArticlesHelper

  def articles_by_type
    @type = Articletype.find_by_slug(params[:slug])
    @type_ids = @type.id
    @menu_class = @type.color_class
    @title = @type.title
    render "index"
  end

  def show
    @article = Article.find(params[:id]) || not_found

    # redirect to right subdomain
    if @article.project and not Subdomain.matches?(request)
      redirect_to article_path(@article) and return
    end

    # redirect to forbidden if article only for signed
    if @article.only_for_signed and not user_signed_in?
      return forbidden
    end

    if @article.type.page and not @article.project
      @menu_class = @article.type.page.color_class
    elsif @article.project
      @menu_class = 'projects'
    elsif @article.is_news?
      @menu_class = 'news'
    else
      @menu_class = 'articles'
    end

    articles = Article.visible.where("articletype_id = ?", @article.articletype_id)
    if @article.project
      articles = articles.where("project_id = ?", @article.project_id)
    else
      articles = articles.where("project_id < 1") # becouse in mysql value is 0, in postgres NULL
    end
    @next = articles.where("published_at > ?", @article.published_at).last
    @previous = articles.where("published_at < ?", @article.published_at).first
    @more = articles.where("id != ?", @article.id).limit(5)

    render "show"
  end

  def index

#    params[:page] = params.fetch(:page, 1).to_i
#    params[:per_page] = params.fetch(:per_page, 20).to_i

    articles = Article.visible
    if not params[:type_ids].blank?
      type_ids = params[:type_ids]
      articles = articles.scoped_by_articletype_id(type_ids)

      # media widget for index and publications pages
      if params[:project_ids].blank? and type_ids.is_a? Array and type_ids.count > 1 and type_ids.include? Articletype::MEDIA_ID.to_s
        widgets[3-2] = {:type => 'media', :count => 4, :title => 'СМИ о фонде', :articles => articles.media}
        articles = articles.not_media
      end
    end

    types_count = {}

    if not params[:query].blank?
      Articletype.all.each do |type|
        types_count[type.id] = Article.search(params[:query], :with => {:id => articles.map(&:id), :articletype_id => type.id}).count()
      end
      order = params[:order] == 'relevance' ? "@relevance DESC" : "published_at DESC"
      articles = Article.search(params[:query], :order => order, :with => {:id => articles.map(&:id)}, :page => params[:page], :per_page => params[:per_page])
    else
      articles = articles#.paginate(:page => params[:page], :per_page => params[:per_page])
    end

    @articles = articles

    respond_to do |format|
       format.html
    end
  end

end