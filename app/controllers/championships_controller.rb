class ChampionshipsController < ApplicationController

  before_filter :set_context_championships

  def set_context_championships
    @championships = Championship.where(:archive => false)
    @archive = Championship.where(:archive => true).count > 0
  end

  def index
    @championship = Championship.first
    render 'show'
  end

  def show
    @championship = Championship.find(params['id'])
  end

  def archive
    @archive_championships = Championship.where(:archive => true)
  end
end