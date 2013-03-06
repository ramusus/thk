# -*- coding: utf-8 -*-
class Articletype < ActiveRecord::Base

  PUBLICATION_ID = 1

  scope :publication, where(:id => PUBLICATION_ID)

  scope :not_media, where('id != ?', PUBLICATION_ID)

  attr_accessible :name, :name_plural, :slug, :title, :filter_hide

  rails_admin do
    list do
      include_fields :name
    end
    show do
      include_fields :name
    end
    edit do
      include_fields :name
    end
  end

end