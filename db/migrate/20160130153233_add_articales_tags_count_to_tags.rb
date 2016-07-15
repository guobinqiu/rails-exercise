class AddArticalesTagsCountToTags < ActiveRecord::Migration
  def up
    add_column :tags, :articles_tags_count, :integer, default: 0, null: false
  end

  def down
    remove_column :tags, :articles_tags_count
  end
end
