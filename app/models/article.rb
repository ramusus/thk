# -*- coding: utf-8 -*-
class Article < ActiveRecord::Base

  scope :not_announces, where("articletype_id != ?", Articletype::PUBLICATION_ID)

  scope :announces, where(:articletype_id => Articletype::PUBLICATION_ID)

#  scope :main, where(:main => true)
#  scope :main_for_project, where(:main_for_project => true)
  scope :visible, where(:hide => false)
#  scope :visible_on_index, visible.where(:hide_on_index => false)

  default_scope :order => 'published_at DESC, id DESC'
  attr_accessible :title, :subtitle, :image, :url, :main, :hide, :content,
    :old_id, :published_at, :title_seo, :right_column, :articletype_id, :delete_image, :old_group_id,
    :social_image, :delete_social_image

  has_attached_file :image, :styles => {:square => "230x230"}
  has_attached_file :social_image, :styles => {:square => "200x200"}
  attr_accessor :delete_image
  attr_accessor :delete_social_image
  before_validation { self.image = nil if self.delete_image == '1' }
  before_validation { self.social_image = nil if self.delete_social_image == '1' }

  belongs_to :articletype

#  define_index do
##    indexes published_at, :sortable => true
#    indexes title
#    indexes subtitle
#    indexes content
#    indexes author
#
#    # attributes
#    has project_id, articletype_id, published_at, id
#  end

  def save(args={})
    if not self.published_at
      self.published_at = Time.now
    end
    if not self.articletype_id
      self.articletype_id = Articletype::PUBLICATION_ID
    end
    super(args)
  end

  def type
    self.articletype
  end

  def is_video?
    self.type.id == Articletype::VIDEO_ID
  end

  rails_admin do
    list do
      include_fields :published_at, :title, :articletype, :main, :hide
    end
    show do
      include_fields :title, :published_at, :subtitle, :main
      include_fields :content do
        pretty_value do
          value.html_safe
         end
      end
    end
    edit do
      include_fields :title do
        help 'Основной заголовок, желательно не длиннее 100 символов'
      end
      include_fields :subtitle do
        help 'Краткое описание под заголовком, желательно до 200 символов'
      end
      include_fields :image do
        help 'Картинка для листинга материалов (уменьшается по ширине до размера колонки)'
      end
      include_fields :articletype do
        help 'Тип публикации, она же метка на цветной вкладке в листинге материалов'
      end
      include_fields :url do
        help 'Указывается только если необходим переход с анонса на внешний проект (тело материала в таком случае уже не показывается)'
      end
      include_fields :hide do
        help 'Скрытый материал доступен всем по прямой ссылке, он скрывается только из листингов'
      end
      include_fields :published_at do
      end
      include_fields :content do
      end
#      include_fields :right_column do
#        help 'Выводится под списком смежных материалов "Еще по теме"'
#      end
#      include_fields :social_image do
#        help 'Картинка проекта используемая в социальных сетях (уменьшается до размера 89 на 89 пикс)'
#      end
      include_fields :content, :right_column do
        ckeditor true
        ckeditor_config_js '/javascripts/ckeditor/config.js'
      end
    end
  end

end