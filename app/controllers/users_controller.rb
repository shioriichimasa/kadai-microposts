class UsersController < ApplicationController
  # ログイン必須にするアクションを設定
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]

  # 一覧の表示。page~~はページネーション
  def index
    @pagy, @users = pagy(User.order(id: :desc), items: 25)
  end

  def show
    @user = User.find(params[:id])
    @pagy, @microposts = pagy(@user.microposts.order(id: :desc))
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  # フォロー／フォロワー一覧表示
  def followings
    @user = User.find(params[:id])
    @pagy, @followings = pagy(@user.followings)
    counts(@user)
  end

  def followers
    @user = User.find(params[:id])
    @pagy, @followers = pagy(@user.followers)
    counts(@user)
  end
  
  def likes
    # idでユーザーを指定
    @user = User.find(params[:id])
    # 上で指定したuser_idが持つlikesを指定
    @pagy, @likes = pagy(@user.likes)
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end