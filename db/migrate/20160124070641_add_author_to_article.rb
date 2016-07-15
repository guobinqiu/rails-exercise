class AddAuthorToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :author, :string
  end
end
