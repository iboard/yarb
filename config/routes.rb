# -*- encoding : utf-8 -*-
#
Yarb::Application.routes.draw do

  root 'landings#index'

  match 'set_locale/:locale' => 'application#set_locale',      via: 'GET',  as: 'set_locale'

  match 'sign_in'            => 'session#new',                 via: 'GET',  as: 'sign_in'
  match 'sign_in'            => 'session#create',              via: 'POST', as: 'create_session'
  match 'sign_out'           => 'session#delete',              via: 'GET',  as: 'sign_out'

  match 'sign_up'            => 'sign_up#new',                 via: 'GET',  as: 'sign_up'
  match 'sign_ups'           => 'sign_up#create',              via: 'POST', as: 'sign_ups'
  match 'sign_up/accept_invitation/:token' => 'sign_up#accept_invitation', via: 'GET', as: 'accept_sign_up_invitation'

  match '/auth/:provider/callback' => 'session#create',        via: 'GET'
  match '/auth/identity/register'  => 'users#create',          via: 'POST'
  match '/auth/failure'            => 'session#failure',       via: 'GET'
  match '/sign_up/complete_auth'   => 'session#complete_auth', via: 'POST'


  resources :users
  resources :sign_up_invitations, only: [:index, :new, :create, :destroy]

  resources :pages do
    collection do
      post 'update_order'
    end
  end

end
