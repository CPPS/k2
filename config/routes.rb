require 'sidekiq/web'

Rails.application.routes.draw do
  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :servers, only: [:index, :show]
	resources :problems, only: [:index]
	resources :users, only: [:index, :show, :new, :create]

	#Sidekiq ui
	mount Sidekiq::Web => '/sidekiq'
end
