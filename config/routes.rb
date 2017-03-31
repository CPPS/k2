require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root	'dashboard#index'

	get	'/login',	to: 'sessions#new'
	post	'/login',	to: 'sessions#create'
	delete	'/logout',	to: 'sessions#destroy'
	get	'/signup',	to: 'users#new'
	get	'/random',	to: 'exploration#random'

	get	'/problems/:server_id/:short_name',	to: 'problems#show', as: :kaas #Only way that works for some reason

	resources :servers, 	only: [:index, :show]
	resources :problems, 	only: [:index]
	resources :users, 	only: [:index, :show, :create]
	delete	'/accounts',	to: 'accounts#destroy' #oops
	resources :accounts,	only: [:show, :new, :create, :destroy]

	namespace :api do
		namespace :v1 do
			get 'servers/:id/problems',	to: 'servers#problems'
			get 'servers/:id/submissions',	to: 'servers#submissions'
			get 'servers/:id/accounts',	to: 'servers#accounts'
			resources :servers,	only: [:index, :show]
			resources :problems,	only: [:index, :show]
			resources :submissions,	only: [:index, :show]
			resources :accounts,	only: [:index, :show]
		end
	end
	
	#Sidekiq ui: only accessible if logged in
	mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
end
