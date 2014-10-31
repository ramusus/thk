# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController

  def articles_by_type
    @type = Articletype.find_by_slug(params[:slug])
    @context = {type: @type.id}
    @title = @type.name
    # @articles = Article.published.scoped_by_articletype_id(@type).page(params[:page])    
    render "index"
  end

  def articles_mhl
    #@articles = Article.published.where("mhl = True")
    @context = {mhl: true}    
    @title = "МХЛ"
    render "index"
  end

  def show
    @article = Article.published.find(params[:id]) || not_found
    @articles = Article.published.where("articletype_id = ? AND id != ?", @article.articletype_id, @article.id).limit(3)
    render "show"
  end

  def index
    @context = {}
    respond_to do |format|
      format.html
      format.json {render partial: 'articles/index', object: get_articles}
    end
  end

  def get_articles
    scope = Article.published.includes(:articletype)
    scope = scope.scoped_by_articletype_id(params[:type]) if params[:type]
    scope = scope.where("mhl = True") if params[:mhl]
    scope = scope.on_index if params[:on_index]
    page = params[:page] ? params[:page].to_i : 1
    per_page = params[:per_page] ? params[:per_page].to_i : 21
    @articles = scope.page(page).per_page(per_page)
  end

  def old_index

#    params[:page] = params.fetch(:page, 1).to_i
#    params[:per_page] = params.fetch(:per_page, 20).to_i

    

    #unless params[:type_ids].blank?
    #  type_ids = params[:type_ids]
    #  articles = articles.scoped_by_articletype_id(type_ids)
    #end

    #types_count = {}

    #if not params[:query].blank?
    #  Articletype.all.each do |type|
    #    types_count[type.id] = Article.search(params[:query], :with => {:id => articles.map(&:id), :articletype_id => type.id}).count()
    #  end
    #  order = params[:order] == 'relevance' ? "@relevance DESC" : "published_at DESC"
    #  articles = Article.search(params[:query], :order => order, :with => {:id => articles.map(&:id)}, :page => params[:page], :per_page => params[:per_page])
    #else
    #  articles = articles#.paginate(:page => params[:page], :per_page => params[:per_page])
    #end

    @articles = articles #.page(params[:page])    
    respond_to do |format|
       format.html
    end
  end

end