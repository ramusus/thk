class ChampionshipsController < ApplicationController
  def index
    @championships = Championship.all
    @championship = Championship.first
    render 'show'
  end

  def show
    @championships = Championship.all
    @championship = Championship.find(params['id'])
  end
end