class HomeController < ApplicationController

  def index
    # @articles = Article.published.on_index
    @slides = Slide.visible

    respond_to do |format|
      format.html
    end
  end

end