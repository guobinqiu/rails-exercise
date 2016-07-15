class RenameArticlesTagsCount < ActiveRecord::Migration
  def change
    #名字必须是articles_count
    rename_column :tags, :articles_tags_count, :articles_count
  end
end
