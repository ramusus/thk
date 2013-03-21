# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base

  scope :past, where("date < ?", Time.now)
  scope :future, where("date > ?", Time.now)
  attr_accessible :date, :championship_id, :rival, :team, :home, :score_host, :score_guest, :finished

  belongs_to :championship

  TEAM_OPTIONS = [['ТХК', 1], ['Тверичи', 2]]
  FINISHED_OPTIONS = [['Нормальное', '', 1], ['Овертайм', 'ОТ', 2], ['Булиты', 'Б', 3], ['Не завершилась', '', 4]]
  validates_inclusion_of :team, :in => TEAM_OPTIONS.collect{|pair| pair[1]}
  validates_inclusion_of :finished, :in => FINISHED_OPTIONS.collect{|pair| pair[2]}

  def team_enum
    TEAM_OPTIONS
  end

  def team_text
    TEAM_OPTIONS.select{|x| x[1] == team}[0][0]
  end

  def finished_enum
    FINISHED_OPTIONS
  end

  def finished_text_short
    FINISHED_OPTIONS.select{|x| x[2] == finished}[0][1]
  end

  def finished?
    return self.finished != 4
  end

  def win?
    if self.score_host and self.score_guest
      (self.home and self.score_host > self.score_guest) or (not self.home and self.score_host < self.score_guest)
    end
  end

  def loss?
    if self.score_host and self.score_guest
      (self.home and self.score_host < self.score_guest) or (not self.home and self.score_host > self.score_guest)
    end
  end

  rails_admin do
    list do
      include_fields :championship, :date, :team, :rival
    end
    show do
      include_fields :team, :rival
    end
    edit do
      include_fields :date, :championship
      field :team, :enum do
        enum_method do
          :team_enum
        end
      end
      include_fields :rival, :home, :score_host, :score_guest
      field :finished, :enum do
        enum_method do
          :finished_enum
        end
      end
    end
  end

end
