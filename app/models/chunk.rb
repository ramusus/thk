# -*- coding: utf-8 -*-
class Chunk < ActiveRecord::Base
  attr_accessible :title, :code, :content, :visible

  rails_admin do
    list do
      include_fields :title, :code, :visible
    end
    edit do
      include_fields :title, :code, :visible, :content
#      include_fields :content do
#        ckeditor true
#        ckeditor_config_js '/javascripts/ckeditor/config.js'
#      end
    end
  end

end