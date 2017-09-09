Rails.application.routes.draw do
  resources :sales
  get 'sales/user/:id', to: 'sales#by_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
