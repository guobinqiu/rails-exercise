module ArticlesHelper
  #实时缓存
  def cache_key_for_articles_list(articles, search)
    prefix = "articles/list"
    if articles.any?
      seq_no = articles.map(&:updated_at).max.to_s(:number)
    end
    if search.present?
      prefix = prefix + "/search"
    end
    "#{prefix}/#{seq_no}"
  end
end
