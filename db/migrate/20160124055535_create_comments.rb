#rails generate model Comment commenter:string body:text article:references
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :article, index: true#, foreign_key: true
      #t.belongs_to :article

      t.timestamps #null: false
    end
  end
end
