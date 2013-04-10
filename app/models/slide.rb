class Slide < ActiveRecord::Base
  scope :visible, where(:hide => false)
  default_scope :order => 'position DESC'
  attr_accessible :hide, :content, :color, :background_color, :link, :position, :image, :inverted

  has_attached_file :image, :styles => {:slide => "804x370"}

  def save(args={})
    if not self.position
      self.position = 0
    end
    super(args)
  end

  rails_admin do
    list do
      include_fields :content
    end
    show do
      include_fields :content
    end
    edit do
      include_fields :hide, :content, :link, :position, :image, :inverted
    end
  end


end