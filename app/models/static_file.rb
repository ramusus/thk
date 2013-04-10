class StaticFile < ActiveRecord::Base
  attr_accessible :alt, :code, :file, :delete_file

  has_attached_file :file
  attr_accessor :delete_file
  before_validation { self.file = nil if self.delete_file == '1' }
end