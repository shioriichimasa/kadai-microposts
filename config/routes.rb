Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  #ユーザーの新規URLを/signupにする
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create] do
    member do
      get :followings
      get :followers
      get :likes
    end    
  end
  
  #必要なアクションのみ指定。createで投稿、destroyで投稿を削除
  resources :microposts, only: [:create, :destroy] 
  # ログインユーザーがフォロー、フォロー解除できるようにするルーティング
  resources :relationships, only: [:create, :destroy]
  
  # ログインユーザがお気に入りを登録、登録削除できるようにするルーティング
  resources :favorites, only: [:create, :destroy]

end
