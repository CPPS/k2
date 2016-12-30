require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root	'sessions#new'
	
	get	'/login',	to: 'sessions#new'
	post	'/login',	to: 'sessions#create'
	delete	'/logout',	to: 'sessions#destroy'
	get	'/signup',	to: 'users#new'

	get	'/problems/:server_id/:short_name',	to: 'problems#show', as: :kaas #Only way that works for some reason

	resources :servers, 	only: [:index, :show]
	resources :problems, 	only: [:index]
	resources :users, 	only: [:index, :show, :create]

	#Sidekiq ui
	mount Sidekiq::Web => '/sidekiq'
end
