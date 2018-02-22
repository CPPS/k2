require 'sidekiq/web'

Rails.application.routes.draw do
  get 'help/show'

  get 'submissions/show'

	# Add devise routes
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root	'leaderboard#show'

	#get	'/login',	to: 'sessions#new'
	#post	'/login',	to: 'sessions#create'
	#delete	'/logout',	to: 'sessions#destroy'
	#get	'/signup',	to: 'users#new'
	get	'/random',	to: 'exploration#random'
	get	'/search/:query',	to: 'exploration#search'

	# Navbar paths
	get	'/leaderboard',	to: 'leaderboard#show'
	get	'/dashboard',	to: 'dashboard#index'
	get	'/submissions',	to:'submission#show'
	get	'/help',	to:'help#show'

	# Only way that works for some reason
	get	'/problems/:server_id/:short_name',	to: 'problems#show', as: :kaas
	get	'/scoreboard/:problem_names/:account_ids',	to: 'scoreboard#show'

	resources :servers,	only: %i[index show]
	get '/auth', to: 'servers#auth'
	resources :problems,	only: %i[index]
	#resources :users,	only: %i[index show create]
	delete	'/accounts',	to: 'accounts#destroy' # oops
	resources :accounts,	only: %i[show new create destroy]

	namespace :api do
		namespace :v1 do
			get 'servers/:id/problems',	to: 'servers#problems'
			get 'servers/:id/submissions',	to: 'servers#submissions'
			get 'servers/:id/accounts',	to: 'servers#accounts'
			resources :servers,	only: %i[index show]
			resources :problems,	only: %i[index show]
			resources :submissions,	only: %i[index show]
			resources :accounts,	only: %i[index show]
		end
	end

	# Sidekiq ui: only accessible if logged in
	authenticate :user, ->(u) { u.admin? } do
		mount Sidekiq::Web => '/sidekiq'
	end
end
