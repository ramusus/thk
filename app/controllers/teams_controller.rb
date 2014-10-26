class TeamsController < ApplicationController
  
  def thk
    params['id'] = 1
    show
  end
  
  def mhk
    params['id'] = 2
    show
  end

  def show
    @team = Team.find(params['id'])
    @people = @team.people
    render 'show'
  end
  
end