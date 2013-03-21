class ChampionshipsController < ApplicationController
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
  end
end