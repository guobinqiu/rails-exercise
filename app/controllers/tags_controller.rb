class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:alert] = '数据已经保存啦' #这种方式更灵活，可以自定义key名
      redirect_to new_tag_path#, alert: '数据已经保存啦'
    else
      flash.now[:alert] = '总之哪里出错啦' #render要用now，redirect_to不用加now
      render :new

      #各种等效写法
      #render 'new'
      #render 'new.html.erb'

      #render 'tags/new'
      #render 'tags/new.html.erb'

      #render action: 'new'
      #render action: :new

      #render template: 'tags/new'            #对
      #render template: 'tags/new.html.erb'   #对

      #render template: 'new'                 #错
      #render template: 'new.html.erb'        #错
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    tag = Tag.find(params[:id])
    tag.update(tag_params)
    redirect_to tags_path
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to tags_path
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
