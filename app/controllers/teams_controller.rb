class TeamsController < ApplicationController
  def thk
    @team = Team.find(1)
    @people = @team.people
    render "show"
  end
  def mhk
    @team = Team.find(2)
    @people = @team.people
    render 'show'
  end
end