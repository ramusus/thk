# -*- coding: utf-8 -*-
class Person < ActiveRecord::Base

  scope :forwards, where(:occupation => 1)
  scope :goalkeepers, where(:occupation => 2)
  scope :coachs, where(:occupation => 3)
  scope :direction, where(:occupation => 4)

  attr_accessible :age, :birthyear, :description, :efficiency, :experience, :fouls, :goals, :height, :image, :name, :number, :position, :temporary, :weight, :delete_image, :occupation

  has_attached_file :image, :styles => {:square => "111x111"}
  attr_accessor :delete_image
  before_validation { self.image = nil if self.delete_image == '1' }

  OCCUPATION_OPTIONS = [['нападающие', 1], ['вратари', 2], ['тренеры', 3], ['руководство', 4]]
  validates_inclusion_of :occupation, :in => OCCUPATION_OPTIONS.collect{|pair| pair[1]}

  def occupation_enum
    OCCUPATION_OPTIONS
  end

  def occupation_text
    OCCUPATION_OPTIONS.select{|x| x[1] == occupation}[0][0]
  end

  rails_admin do
    list do
      include_fields :name
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :name, :number, :image, :age, :birthyear, :efficiency, :experience, :fouls, :goals, :height, :position, :description, :temporary, :weight
      field :occupation, :enum do
        enum_method do
          :occupation_enum
        end
      end
    end
  end

end