Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :servers, only: [:index, :show]
	resources :problems, pnly: [:index]
end
