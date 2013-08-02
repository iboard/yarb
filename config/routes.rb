Yarb::Application.routes.draw do

  root 'landings#index'
  match 'switch_locale/:locale' => 'application#switch_locale', via: 'GET', as: 'switch_locale'

  resources :pages

end
