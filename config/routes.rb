Rails.application.routes.draw do
root "homes#top"
get "/homes/about" => "homes#about", as: "about"

devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

devise_scope :user do
    post 'public/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

# scope module: :public do
#   get '/searches/search' => 'searches#search'
#   get '/posts/rank' => 'posts#rank'
#   get 'users/confirm_withdraw' => 'users#confirm_withdraw', as: 'confirm_withdraw'
#   patch '/users/withdraw' => 'users#withdraw'
#   get 'genres/:id/genre_rank' => 'genres#genre_rank', as: 'genre_rank'
#   resources :genres, only: [:show]
#   resources :users, only: [:show, :edit,:update]
#   resource :posts, only: [:new,:create]
#   resources :posts, only: [:show,:index,:destroy,:edit,:update] do
#     resource :favorites, only: [:create, :destroy]
#     resources :comments, only: [:create,:destroy,:new]
#   end
# end

scope module: :public do
  get '/searches/search' => 'searches#search'
  resources :genres, only: [:show] do
    member do 
      get 'genre_rank'
    end
  end
  resources :users, only: [:show,:edit,:update] do
    collection do 
      get 'confirm_withdraw'
      patch 'withdraw'
    end
  end
  resources :posts do
    collection do
      get 'rank'
    end
    resources :comments, only: [:create,:destroy,:new]
    resource :favorites, only: [:create, :destroy]
  end
end

namespace :admin do
  resources :posts, only: [:destroy,:show]
    resources :comments, only: [:destroy]
  resources :users, only: [:show,:index,:edit,:update,:destroy]
  patch '/users/withdraw' => 'users#withdraw'
  get 'users/:id/comment_index' => 'users#comment_index'
  resources :genres, only: [:index, :show, :edit, :create, :update]

end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
