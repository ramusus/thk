object @articles
attributes :id, :title, :mhl
node :image do |item|
 item.image.exists? ? item.image(:square) : nil
end
node(:path) {|item| article_path(item) }
node(:type) {|item| item.articletype.name }
node(:type_path) {|item| '/'+(item.articletype.slug) }
node(:day) {|item| l item.published_at, :format => "%d" }
node(:month) {|item| l item.published_at, :format => "%b / %a" }
node(:last_page) {|item| @articles.total_pages }