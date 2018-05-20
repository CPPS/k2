require 'sidekiq/web'

Rails.application.routes.draw do
  get 'achievements/show'

  get 'achievements_controller/show'

  get 'edit_achievement/show'

  get 'achievement_edit_controller/show'

  get 'changelog/index'

  get 'homepage/show'

  get 'help/show'

  get 'submissions/show'

	# Add devise routes
	# Registrations and editing is temporarily disabled due to bugs
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root	'homepage#show'

	#get	'/homepage'	to: 'homepage/show'
	#get	'/login',	to: 'sessions#new'
	#post	'/login',	to: 'sessions#create'
	#delete	'/logout',	to: 'sessions#destroy'
	#get	'/signup',	to: 'users#new'
	get	'/random',	to: 'exploration#random'
	get	'/search/:query',	to: 'exploration#search'

	# Navbar paths
	get	'/leaderboard',	to: 'leaderboard#show'
	get	'/achievements',	to: 'achievements#show'
	get	'/dashboard',	to: 'dashboard#index'
	get	'/changelog',	to: 'changelog#index'
	get	'/submissions',	to:'submission#show'
	get	'/help',	to:'help#show'
	get '/search', to:'submissions#show'
	get '/edit_achievement', to: 'achievement_datum#show'
	post '/update_achievement', to: 'achievement_datum#update'
	post '/reprocess_achievements', to: 'achievement_datum#reprocess'
	delete '/delete_achievement', to: 'achievement_datum#delete'
	post '/new_submission', to:'submissions#process_submit'

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
