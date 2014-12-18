# -*- coding: utf-8 -*-

require 'concerns/birthday_table'

class Person < ActiveRecord::Base

  scope :forwards, where(:occupation => 1)
  scope :defenders, where(:occupation => 5)
  scope :goalkeepers, where(:occupation => 2)
  scope :coaches, where(:occupation => 3)
  scope :direction, where(:occupation => 4)

  belongs_to :team

  attr_accessible :birthyear, :birthday, :description, :notice, :efficiency, :experience, :fouls, :goals, :height, :image, :name, :number, :position, :weight, :delete_image, :occupation, :team_id

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

  def birthyear 
    return birthday.year if birthday
    read_attribute :birthyear
  end

  def self.birthdays
    data = ::BirthdayTable.new
    Person.select('id, name, birthday, position').where('birthday is not null').each do |item|
      data.add(item.birthday, item.serializable_hash)
    end
    data
  end

  def birthday_str
    if birthday
      return Russian::l(birthday, format: '%d %b %Y')
    end
    year = read_attribute :birthyear
    "#{year} Г.Р."
  end

  def stat
    stat = []
    stat.push("#{self.height} РОСТ") if self.height
    stat.push("#{self.weight} ВЕС") if self.weight
    stat.push(birthday_str) if birthday_str
    stat.push("СТАЖ #{self.experience} ЛЕТ") if self.experience

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
      include_fields :name, :team, :number, :image, :birthyear
      field :birthday do
        help 'Укажите день рождения, если персону следует показывать в блоке "Дни рождения" на главной странице сайта'
      end
      
      include_fields :experience, :position, :description, :notice, :weight, :height
      field :occupation, :enum do
        enum_method do
          :occupation_enum
        end
      end
    end
  end

end