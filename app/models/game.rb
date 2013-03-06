# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base
  attr_accessible :date, :name, :result, :score

  RESULT_OPTIONS = [['ПОБЕДА', 1], ['ПРОИГРЫШ', 2], ['НИЧЬЯ', 3]]
  validates_inclusion_of :result, :in => RESULT_OPTIONS.collect{|pair| pair[1]}

  def result_enum
    RESULT_OPTIONS
  end

  def result_text
    RESULT_OPTIONS.select{|x| x[1] == occupation}[0][0]
  end

  rails_admin do
    list do
      include_fields :name
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :date, :name, :score
      field :result, :enum do
        enum_method do
          :result_enum
        end
      end
    end
  end

end
