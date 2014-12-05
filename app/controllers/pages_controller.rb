class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug(params[:slug]) || not_found

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def test
    raise "ACCESS DENIED" if Rails.env != 'development'    
    @persons = Person.select('id, name, birthday, position').where('birthday is not null').all
    @birthdays = Person.birthdays.find(Date.today, Date.today + 3.month)
  end

end