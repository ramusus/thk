# -*- coding: utf-8 -*-
class Articletype < ActiveRecord::Base

  INTERVIEW_ID = 1
  NEWS_ID = 2
  REPORT_ID = 3
  REVIEW_ID = 4

#  scope :not_media, where('id != ?', PUBLICATION_ID)

  attr_accessible :name, :name_plural, :slug, :title, :filter_hide

  def to_s
    self.name
  end

  def path
    '#'
  end

  rails_admin do
    list do
      include_fields :name, :slug
    end
    show do
      include_fields :name, :slug
    end
    edit do
      include_fields :name, :slug
    end
  end

end