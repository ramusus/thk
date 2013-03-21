# -*- coding: utf-8 -*-
class Person < ActiveRecord::Base

  scope :forwards, where(:occupation => 1)
  scope :defenders, where(:occupation => 5)
  scope :goalkeepers, where(:occupation => 2)
  scope :coaches, where(:occupation => 3)
  scope :direction, where(:occupation => 4)

  belongs_to :team

  attr_accessible :birthyear, :description, :notice, :efficiency, :experience, :fouls, :goals, :height, :image, :name, :number, :position, :weight, :delete_image, :occupation, :team_id

  has_attached_file :image, :styles => {:square => "111x111"}
  attr_accessor :delete_image
  before_validation { self.image = nil if self.delete_image == '1' }

  OCCUPATION_OPTIONS = [['нападающие', 1], ['вратари', 2], ['тренеры', 3], ['руководство', 4], ['защитники', 5]]
  validates_inclusion_of :occupation, :in => OCCUPATION_OPTIONS.collect{|pair| pair[1]}

  def occupation_enum
    OCCUPATION_OPTIONS
  end

  def occupation_text
    OCCUPATION_OPTIONS.select{|x| x[1] == occupation}[0][0]
  end

  def stat
    stat = []
    if self.height
      stat.push("#{self.height} РОСТ")
    end
    if self.weight
      stat.push("#{self.weight} ВЕС")
    end
    if self.birthyear
      stat.push("#{self.birthyear} Г.Р.")
    end
    if self.experience
      stat.push("СТАЖ #{self.experience} ЛЕТ")
    end
    stat.join(' / ')
  end

  rails_admin do
    list do
      include_fields :name, :team, :number
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :name, :team, :number, :image, :birthyear, :experience, :position, :description, :notice, :weight, :height
      field :occupation, :enum do
        enum_method do
          :occupation_enum
        end
      end
    end
  end

end