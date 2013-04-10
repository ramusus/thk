  class ApplicationController < ActionController::Base

#  require 'domainatrix'

#  include ExceptionLogger::ExceptionLoggable # loades the module
#  rescue_from Exception, :with => :log_exception_handler # tells rails to forward the 'Exception' (you can change the type) to the handler of the module

  protect_from_forgery
  before_filter :set_locale, :set_context

  def set_context

    @articletypes = Articletype.where(:filter_hide => false)
    @favorites = Article.unscoped.where(:favorite => true).order('position DESC')

    ['partners','social_links','copyright','header_menu','footer_menu','info_vhl'].each do |var_name|
      chunk = Chunk.find_by_code(var_name)
      if chunk and chunk.visible
        chunk = chunk.content.html_safe
      else
        chunk = ''
      end
      self.instance_variable_set('@' + var_name, chunk)
    end

    ['background'].each do |var_name|
      file = StaticFile.find_by_code(var_name)
      if not file or not file.file or not file.file.exists?
        file = false
      end
      self.instance_variable_set('@file_' + var_name, file)
    end

  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def index
    @articles = Article.published.on_index
    @slides = Slide.visible
    @games = Game

    respond_to do |format|
      format.html
    end
  end

  def search
    @articletypes = Articletype.all
    @project = false
    if not request.env['HTTP_REFERER'].blank?
      url = Domainatrix.parse(request.env['HTTP_REFERER'])
      if not url.subdomain.blank?
        @project = Project.find_by_subdomain(url.subdomain)
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def forbidden
    raise ActionController::RoutingError.new('Forbidden')
  end

  def set_cookie(name, value)
    cookies[name] = {:expires => 5.year.from_now, :value => Marshal::dump(value)}
  end

  def read_cookie(name)
    if cookies[name]
      Marshal::load(cookies[name])
    else
      nil
    end
  end

end