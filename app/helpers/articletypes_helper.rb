module ArticletypesHelper

  def articletype_path(articletype)
    params ? '/' + articletype.slug : publications_path
  end

end