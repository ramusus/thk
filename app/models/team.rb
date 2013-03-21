# -*- coding: utf-8 -*-
class Team < ActiveRecord::Base
  attr_accessible :name, :people_statistic

  has_many :games
  has_many :people

  def to_s
    self.name
  end

  rails_admin do
    list do
      include_fields :name
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :name
      include_fields :people_statistic do
        ckeditor true
        ckeditor_config_js '/javascripts/ckeditor/config.js'
      end
    end
  end

end