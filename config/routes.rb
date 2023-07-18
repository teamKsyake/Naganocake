Rails.application.routes.draw do

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
    get 'admin/sign_in' => 'sessions#new'
    post 'admin/sign_in' => 'sessions#create'
    delete 'admin/sign_out' => 'sessions#destroy'
    # 管理者（ログイン画面、ログイン、ログアウト）

    root to: 'homes#top'

    resources :items, only:[:index, :new, :create, :show, :edit, :update]
    # 商品（一覧、商品新規登録、商品情報の新規登録、詳細、編集、情報の更新）

    resources :genres, only:[:index, :create, :edit, :update]
    # ジャンル（管理画面、データ登録、編集、データ更新）

    resources :customers, only:[:index, :show, :edit, :update]
    # 顧客（一覧、詳細、編集、情報の更新）

    resources :orders, only: [:show, :update]
    patch 'admin/orders/:id' => 'order_items#update'
    # 注文詳細画面（ステータスの更新）
  end



  # 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  namespace :public do
    root to: 'homes#top'
    get "/home/about" => "homes#about", as: "about"

    resources :items, only:[:index, :show]
    # 商品（一覧、詳細）

    get 'customers/sign_up' => 'registrations#new'
    # 顧客会員登録画面

    post 'customers' => 'registrations/create'
    # 顧客会員登録

    get 'customers/sign_in' => 'sessions/new'
    # 顧客ログイン画面

    post 'customers/sign_in' => 'sessions/create'
    # 顧客ログイン

    delete 'customers/sign_out' => 'sessions/destroy'
    # 顧客ログアウト

    get 'customers/mypage' => 'customers#show'
    # 顧客のマイページ

    get 'customers//information/edit' => 'customers#edit'
    # 顧客の会員登録情報編集

    patch 'customers/infomation/update' => 'customers#update'
    # 顧客の登録情報更新

    get 'customers/check' => 'customers#check'
    # 顧客の退会確認画面

    patch 'customers/withdrawal' => 'customers#withdrawal'
    # 顧客の退会処理(ステータスの更新)

    resources :cart_items, only:[:index, :update, :destroy, :create]
    # カート内商品（一覧、更新、削除、追加）

    delete 'cart_items/destroy_all' => 'cart_item#destroy_all'
    # カート内商品を全て削除

    resources :orders, only:[:new, :create, :index, :show]
    # 注文情報入力、確定、履歴、履歴詳細

    post 'orders/check' => 'orders#check'
    # 注文情報確認

    get 'orders/complete_order' => 'orders#complete_order'
    # 注文完了画面

    resources :shippings, only:[:index, :edit, :create, :update, :destroy]
    # 配送先登録（一覧、編集、登録、更新、削除）
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
