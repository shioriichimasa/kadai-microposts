
class FavoritesController < ApplicationController
  # ログイン必須処理
  before_action :require_user_logged_in
  # お気に入り追加の処理
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_to root_url
  end
  
  # お気に入り削除の処理
  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_to root_url
  end
end