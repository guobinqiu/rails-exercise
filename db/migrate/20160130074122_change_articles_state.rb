class ChangeArticlesState < ActiveRecord::Migration
  #def change
  #  change_column :articles, :state, :integer
  #end

  def up
    change_column :articles, :state, :integer
  end

  def down
    change_column :articles, :state, :string
  end
end