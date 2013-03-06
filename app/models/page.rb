# -*- coding: utf-8 -*-
class Page < ActiveRecord::Base

  scope :visible, where(:visible => true)
  default_scope :order => 'position DESC'
  attr_accessible :title, :slug, :content, :position, :visible

  def save(args={})
    if not self.position
      self.position = 0
    end
    super(args)
  end

  rails_admin do
    list do
      include_fields :title, :slug, :visible, :position
    end
    show do
      include_fields :title, :slug, :visible
      include_fields :content do
        pretty_value do
          value.html_safe
         end
      end
    end
    edit do
      include_fields :title, :slug
      include_fields :visible do
        help 'Отображать ссылку на страницу в автоматических листингах'
      end
      include_fields :position
      include_fields :content do
        ckeditor true
        ckeditor_config_js '/javascripts/ckeditor/config.js'
      end
    end
  end

end