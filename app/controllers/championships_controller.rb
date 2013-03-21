class ChampionshipsController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @championships = Championship.all
    @championship = Championship.first
    @games = @championship.games
    render 'show'
  end

  def show

    @championships = Championship.all
    @championship = Championship.find(params['id'])
    @games = @championship.games

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end