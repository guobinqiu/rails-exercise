class CommentsController < ApplicationController
  def create
    #{"utf8"=>"✓", "authenticity_token"=>"r9bIMu2YanAB5zfP2V+B7HKXJXmE5mXkpezDlp6v4y3FANLjoXltrgyYdruZTH5vwlfQlouDOYZ/iPDDpZPhZg==", "comment"=>{"commenter"=>"", "body"=>""}, "commit"=>"提交", "controller"=>"comments", "action"=>"create", "article_id"=>"8"}
    #render plain: params.inspect

    #puts request.format #text/javascript
    #render js: 'alert("hello")'

    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    #redirect_to article_path(@article)

    @comments = @article.comments.order(created_at: :desc).page(params[:page])

    #如果请求头是js会调用下面一行，如果是html会调用上面一行
    respond_to do |format|
      format.html { redirect_to article_path(@article) }
      #format.js { render 'show_more' } #错误，搜寻路径comments/show_more, application/show_more找不到
      #format.js { render 'articles/show_more' } #正确
      format.js { render 'articles/show' }
    end
  end

  def destroy
    #@comment = Comment.find(params[:id])
    #@comment.destroy
    #@article = @comment.article

    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
