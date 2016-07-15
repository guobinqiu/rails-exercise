class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    @picture = @user.picture || @user.build_picture
  end

  def update
    #最原始的上传图片到本地目录
    #uploaded_io = params[:user][:avatar]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #  file.write(uploaded_io.read)
    #end

    # 使用carrierwave和上面等价的写法
    #uploader = AvatarUploader.new
    #uploader.store!(params[:user][:avatar])

    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def upload
    @user = User.find(params[:id])
    if @user.update_attribute(:avatar, params[:user][:avatar])
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js { render 'upload' }
      end
    else
      render 'edit'
    end
  end

  def signup
    @user = User.new
  end

  def login
  end

  def create_login_session
    #render plain: params.inspect

    @user = User.find_by(name: params[:user][:name])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.auth_token
      redirect_to session[:return_to] || articles_path
    else
      render 'login'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #Active Job方式
      #同步发送邮件
      #UserMailer.welcome_email_smtp(@user.id).deliver_now
      #UserMailer.welcome_email_http(@user.id).deliver_now

      #异步发送邮件
      #https://github.com/mperham/sidekiq/wiki/Active-Job
      #UserMailer.welcome_email_smtp(@user.id).deliver_later
      UserMailer.welcome_email_http(@user.id).deliver_later

      #异步任务
      #ExampleJob.perform_later(@user.id)

      #异步任务里发送邮件
      #WelcomeEmailJobSMTP.perform_later(@user.id)
      #WelcomeEmailJobHTTP.perform_later(@user.id)
      #运行结果：
      #---------------------------------------------------------------------------------------- start ExampleJob
      #---------------------------------------------------------------------------------------- start WelcomeEmailJobSMTP
      #---------------------------------------------------------------------------------------- start WelcomeEmailJobHTTP
      #---------------------------------------------------------------------------------------- end WelcomeEmailJobHTTP
      #---------------------------------------------------------------------------------------- end WelcomeEmailJobSMTP
      #----------------------------------------------------------------------------------------fafds
      #---------------------------------------------------------------------------------------- end ExampleJob

      #纯sidekiq方式
      ExampleWorker.perform_async(@user.id)

      redirect_to articles_path
    else
      render 'signup'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_users_path
  end

  private
  def user_params
    #params.require(:user).permit!

    #picture_attributes的id是必须的
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :auth_token, picture_attributes: [ :id, :name, :imageable_id, :imageable_type ])
  end
end
