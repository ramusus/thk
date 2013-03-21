# -*- coding: utf-8 -*-
class Championship < ActiveRecord::Base
  default_scope :order => 'last_game_date DESC'
  attr_accessible :name, :archive, :link

  has_many :games

  def save(args={})
    games = self.games.order('date DESC')
    self.last_game_date = games.count > 0 ? games[0].date : DateTime.new(1970,1,1)
    super(args)
  end

  rails_admin do
    list do
      include_fields :name
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :name, :archive, :link
    end
  end

end