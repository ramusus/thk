# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController

  def articles_by_type
    @type = Articletype.find_by_slug(params[:slug])
    @articles = Article.published.scoped_by_articletype_id(@type)
    @title = @type.name
    render "index"
  end

  def articles_mhl
    @articles = Article.published.where("mhl = True")
    @title = "МХЛ"
    render "index"
  end

  def show
    @article = Article.published.find(params[:id]) || not_found
    @articles = Article.published.where("articletype_id = ? AND id != ?", @article.articletype_id, @article.id).limit(3)
    render "show"
  end

  def index

#    params[:page] = params.fetch(:page, 1).to_i
#    params[:per_page] = params.fetch(:per_page, 20).to_i

    articles = Article.published
    if not params[:type_ids].blank?
      type_ids = params[:type_ids]
      articles = articles.scoped_by_articletype_id(type_ids)
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