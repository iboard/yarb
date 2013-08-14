Yarb::Application.routes.draw do

  root 'landings#index'
  match 'switch_locale/:locale' => 'application#switch_locale', via: 'GET', as: 'switch_locale'
  match 'sign_in' => 'session#new', via: 'GET', as: 'sign_in'
  match 'sign_in' => 'session#create', via: 'POST', as: 'create_session'

  resources :pages

end
