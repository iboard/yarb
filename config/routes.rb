# -*- encoding : utf-8 -*-
#
Yarb::Application.routes.draw do

  root 'landings#index'
  match 'set_locale/:locale' => 'application#set_locale', via: 'GET', as: 'set_locale'
  match 'sign_in' => 'session#new', via: 'GET', as: 'sign_in'
  match 'sign_in' => 'session#create', via: 'POST', as: 'create_session'
  match 'sign_out' => 'session#delete', via: 'GET', as: 'sign_out'

  resources :pages do
    collection do
      post 'update_order'
    end
  end

end
