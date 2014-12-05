# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base

  default_scope :order => 'date DESC'
  attr_accessible :date, :championship_id, :rival, :team_id, :home, :score_host, :score_guest, :finished

  belongs_to :championship
  belongs_to :team

  FINISHED_OPTIONS = [['Нормальное', '', 1], ['Овертайм', 'ОТ', 2], ['Булиты', 'Б', 3], ['Не завершилась', '', 4]]
#  validates_inclusion_of :finished, :in => FINISHED_OPTIONS.collect{|pair| pair[2]}

  def finished_enum
    FINISHED_OPTIONS
  end

  def finished_text_short
    option = FINISHED_OPTIONS.select{|x| x[2] == finished}[0]
    if option
      option[1]
    end
  end

  def self.past
    self.where("date < ?", Time.now + 3.hours)
  end
  def self.future
    self.where("date > ?", Time.now + 3.hours)
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
      include_fields :team, :rival, :home, :score_host, :score_guest
      field :finished, :enum do
        enum_method do
          :finished_enum
        end
      end
    end
  end

end
